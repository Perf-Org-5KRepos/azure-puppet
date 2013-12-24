require 'spec_helper'

describe Puppet::Face[:azure_vm, :current] do
  let(:vms) { Azure::VirtualMachineManagementService }

  before :each do
    mgmtcertfile = File.expand_path('spec/fixtures/management_certificate.pem')
    @options = {
      management_certificate: mgmtcertfile,
      azure_subscription_id: 'Subscription-id',
      vm_name: 'test-vm',
      cloud_service_name: 'cloud-name'
    }
    Azure.configure do |config|
      config.management_certificate = @options[:management_certificate]
      config.subscription_id        = @options[:azure_subscription_id]
    end
    vms.any_instance.stubs(:delete_virtual_machine).with(anything, anything)
  end

  describe 'option validation' do
    describe 'valid options' do
      it 'should not raise any exception' do
        expect { subject.delete(@options) }.to_not raise_error
      end
    end

    describe '(vm_name)' do
      it 'should validate the vm name' do
        @options.delete(:vm_name)
        expect { subject.delete(@options) }.to raise_error(
          ArgumentError,
          /required: vm_name/
        )
      end
    end

    describe '(cloud_service_name)' do
      it 'cloud_service_name should be optional' do
        @options.delete(:cloud_service_name)
        expect { subject.delete(@options) }.to raise_error(
          ArgumentError,
          /required: cloud_service_name/
        )
      end
    end

    it_behaves_like 'validate authentication credential', :delete

  end
end
