############################################################################
# FindLinphoneCxx.cmake
# Copyright (C) 2023  Belledonne Communications, Grenoble France
#
############################################################################
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
############################################################################
#
# - Find the linphonecxx include files and library
#
#  LINPHONE_TARGETS - Add usable targets into this list.
#  LINPHONECXX_FOUND - system has lib linphonecxx
#  LINPHONECXX_INCLUDE_DIRS - the linphonecxx include directory
#  LINPHONECXX_LIBRARIES - The library needed to use linphonecxx

if(NOT TARGET liblinphone++)
    set(EXPORT_PATH ${LINPHONE_OUTPUT_DIR})
    include(GNUInstallDirs)
    include(${EXPORT_PATH}/${CMAKE_INSTALL_DATADIR}/LinphoneCxx/cmake/LinphoneCxxTargets.cmake)
endif()

if(TARGET liblinphone++)
	list(APPEND LINPHONE_TARGETS liblinphone++)
	set(LINPHONECXX_LIBRARIES liblinphone++)
	get_target_property(LINPHONECXX_INCLUDE_DIRS liblinphone++ INTERFACE_INCLUDE_DIRECTORIES)


	include(FindPackageHandleStandardArgs)
	find_package_handle_standard_args(LinphoneCxx
		DEFAULT_MSG
		LINPHONECXX_INCLUDE_DIRS LINPHONECXX_LIBRARIES
	)

	mark_as_advanced(LINPHONECXX_INCLUDE_DIRS LINPHONECXX_LIBRARIES)

endif()