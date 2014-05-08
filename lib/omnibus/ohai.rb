#
# Copyright 2012-2014 Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'ohai'

module Omnibus
  class Ohai
    class << self
      def method_missing(m, *args, &block)
        if respond_to_missing?(m)
          ohai.send(m, *args, &block)
        else
          super
        end
      end

      def respond_to_missing?(m, include_private = false)
        ohai.respond_missing_to?(m, include_private) || ohai.attribute?(m)
      end

      private

      def ohai
        return @ohai if @ohai

        @ohai = ::Ohai::System.new
        @ohai.require_plugin('os')
        @ohai.require_plugin('platform')
        @ohai.require_plugin('linux/cpu') if @ohai.os == 'linux'
        @ohai.require_plugin('kernel')
        @ohai
      end
    end
  end
end