; This file is part of the TinyCore 6502 MicroKernel,
; Copyright 2022 Jessie Oberreuter <joberreu@moselle.com>.
; As with the Linux Kernel Exception to the GPL3, programs
; built to run on the MicroKernel are expected to include
; this file.  Doing so does not effect their license status.

; Kernel Calls
; Populate the kernel.arg.* variables appropriately, and
; then JSR to one of the velctors below:

			RSSET   $FF00

kernel_NextEvent	RB	4	; Copy the next event into user-space.
kernel_ReadData		RB	4	; Copy primary bulk event data into user-space
kernel_ReadExt		RB	4	; Copy secondary bolk event data into user-space
kernel_Yield		RB	4	; Give unused time to the kernel.
kernel_Putch		RB	4	; deprecated
kernel_RunBlock		RB	4	; Chain to resident program by block ID.
kernel_RunNamed		RB	4	; Chain to resident program by name.
			RB	4	; reserved

blockdev_List		RB	4	; Returns a bit-set of available block-accessible devices.
blockdev_GetName	RB	4	; Gets the hardware level name of the given block device or media.
blockdev_GetSize	RB	4	; Get the number of raw sectors (48 bits) for the given device
blockdev_Read		RB	4	; Read a raw sector (48 bit LBA)
blockdev_Write		RB	4	; Write a raw sector (48 bit LBA)
blockdev_Format		RB	4	; Perform a low-level format if the media support it.
blockdev_Export		RB	4	; Update the FileSystem table with the partition table (if present).

filesys_List		RB	4	; Returns a bit-set of available logical devices.
filesys_GetSize		RB	4	; Get the size of the partition or logical device in sectors.
filesys_MkFS		RB	4	; Creates a new file-system on the logical device.
filesys_CheckFS		RB	4	; Checks the file-system for errors and corrects them.
filesys_Mount		RB	4	; Mark the file-system as available for File and Directory operations.
filesys_Unmount		RB	4	; Mark the file-system as unavailable for File and Directory operations.
filesys_ReadBlock	RB	4	; Read a partition-local raw sector on an unmounted device.
filesys_WriteBlock	RB	4	; Write a partition-local raw sector on an unmounted device.

file_Open		RB	4	; Open the given file for read, create, or append.
file_Read		RB	4	; Request bytes from a file opened for reading.
file_Write		RB	4	; Write bytes to a file opened for create or append.
file_Close		RB	4	; Close an open file.
file_Rename		RB	4	; Rename a closed file.
file_Delete		RB	4	; Delete a closed file.
file_Seek		RB	4	; Seek to a specific position in a file.

dir_Open		RB	4	; Open a directory for reading.
dir_Read		RB	4	; Read a directory entry; may also return VOLUME and FREE events.
dir_Close		RB	4	; Close a directory once finished reading.
dir_MkDir		RB	4	; Create a directory
dir_RmDir		RB	4	; Delete a directory
			
			RB	4	; call gate

net_GetIP		RB	4	; Get the local IP address.
net_SetIP		RB	4	; Set the local IP address.
net_GetDNS		RB	4	; Get the configured DNS IP address.
net_SetDNS		RB	4	; Set the configured DNS IP address.
net_SendICMP		RB	4
net_Match		RB	4

udp_Init		RB	4
udp_Send		RB	4
udp_Recv		RB	4

tcp_Open		RB	4
tcp_Accept		RB	4
tcp_Reject		RB	4
tcp_Send		RB	4
tcp_Recv		RB	4
tcp_Close		RB	4
			
display_Reset		RB	4	; Re-init the display
display_GetSize		RB	4	; Returns rows/cols in kernel args.
display_DrawRow		RB	4	; Draw text/color buffers left-to-right
display_DrawColumn	RB	4	; Draw text/color buffers top-to-bottom

config_GetTime		RB	4
config_SetTime		RB	4
			RB	12	; 65816 vectors
config_GetSysInfo	RB	4
config_SetBPS		RB	4	; Set the serial BPS (should match the SLIP router's speed).

; Kernel Call Arguments
; Populate the structure before JSRing to the associated vector.

		RSSET	$00F0	; Arg block

          ; Event calls
kargs_events	RB	2	; GetNextEvent copies event data here
kargs_pending	RB	1	; Negative count of pending events
kargs_UNION	RB	5
kargs_ext	RB	2
kargs_extlen	RB	1
kargs_buf	RB	2
kargs_buflen	RB	1
kargs_ptr	RB	2

          ; Generic recv
			RSSET	kargs_UNION
kargs_recv_buf		EQU	kargs_buf
kargs_recv_buflen	EQU	kargs_buflen

          ; Run Calls
			RSSET	kargs_UNION
kargs_run_block_id	RB	1

          ; FileSystem Calls
			RSSET	kargs_UNION
kargs_fs_mkfs_drive	RB	1
kargs_fs_mkfs_cookie	RB	1
kargs_fs_mkfs_label	EQU	kargs_buf
kargs_fs_mkfs_label_len	EQU	kargs_buflen

          ; File Calls
			RSSET	kargs_UNION
kargs_file_open_drive	RB	1
kargs_file_open_cookie	RB	1
kargs_file_open_mode	RB	1
kargs_file_open_fname	EQU	kargs_buf
kargs_file_open_fname_len EQU	kargs_buflen

FILE_OPEN_MODE_READ	EQU	0
FILE_OPEN_MODE_WRITE	EQU	1
FILE_OPEN_MODE_END	EQU	2

			RSSET	kargs_UNION
kargs_file_read_stream	RB	1
kargs_file_read_buflen	RB	1

			RSSET	kargs_UNION
kargs_file_write_stream	RB	1
kargs_file_write_buf	EQU	kargs_buf
kargs_file_write_buflen	EQU	kargs_buflen

			RSSET	kargs_UNION
kargs_file_seek_stream	RB	1
kargs_file_seek_position RB	4

			RSSET	kargs_UNION
kargs_file_close_stream	RB	1

			RSSET	kargs_UNION
kargs_file_rename_drive	RB	1
kargs_file_rename_cookie RB	1
kargs_file_rename_old	EQU	kargs_buf
kargs_file_rename_oldlen EQU	kargs_buflen
kargs_file_rename_new	EQU	kargs_ext
kargs_file_rename_newlen EQU	kargs_extlen

			RSSET	kargs_UNION
kargs_file_delete_drive	RB	1
kargs_file_delete_cookie RB	1
kargs_file_fname	EQU	kargs_buf
kargs_file_fname_len	EQU	kargs_buflen

			RSSET	kargs_UNION
kargs_dir_open_drive	RB	1
kargs_dir_open_cooke	RB	1
kargs_dir_open_path	EQU	kargs_buf
kargs_dir_open_path_len	EQU	kargs_buflen

          ; Directory Calls
			RSSET	kargs_UNION
kargs_dir_mkdir_drive	RB	1
kargs_dir_mkdir_cooke	RB	1
kargs_dir_mkdir_path	EQU	kargs_buf
kargs_dir_mkdir_path_len EQU	kargs_buflen

			RSSET	kargs_UNION
kargs_dir_rmdir_drive	RB	1
kargs_dir_rmdir_cooke	RB	1
kargs_dir_rmdir_path	EQU	kargs_buf
kargs_dir_rmdir_path_len EQU	kargs_buflen

			RSSET	kargs_UNION
kargs_dir_read_stream	RB	1
kargs_dir_read_buflen	RB	1

			RSSET	kargs_UNION
kargs_dir_close_stream	RB	1

          ; Drawing Calls
			RSSET	kargs_UNION
kargs_display_x		RB	1
kargs_display_y		RB	1
kargs_display_text	EQU	kargs_buf
kargs_display_color	EQU	kargs_ext
kargs_display_buf	EQU	kargs_buf
kargs_display_buf2	EQU	kargs_ext
kargs_display_buflen	EQU	kargs_buflen


          ; Net calls
kargs_net_socket	EQU	kargs_buf

			RSSET	kargs_UNION
kargs_net_src_port	RB	2
kargs_net_dest_port	RB	2
kargs_net_dest_ip	RB	4

			RSSET	kargs_UNION
kargs_net_accepted	RB	1
kargs_net_buf		EQU	kargs_buf
kargs_net_buflen	EQU	kargs_buflen

			RSRESET
kargs_time_century	RB	1
kargs_time_year		RB	1
kargs_time_month	RB	1
kargs_time_day		RB	1
kargs_time_hours	RB	1
kargs_time_minutes	RB	1
kargs_time_seconds	RB	1
kargs_time_millis	RB	1


; Events
; The vast majority of kernel operations communicate with userland
; by sending events; the data contained in the various events are
; described following the event list.

			RSRESET

			RB	2	; Reserved
			RB	2	; Deprecated
EVENT_JOYSTICK		RB	2	; Game Controller changes.
EVENT_DEVICE		RB	2	; Device added/removed.

EVENT_KEY_PRESSED	RB	2	; Key pressed
EVENT_KEY_RELEASED	RB	2	; Key released.

EVENT_MOUSE_DELTA	RB	2	; Regular mouse move and button state
EVENT_MOUSE_CLICKS	RB	2	; Click counts

EVENT_BLOCK_NAME	RB	2
EVENT_BLOCK_SIZE	RB	2
EVENT_BLOCK_DATA	RB	2	; The read request has succeeded.
EVENT_BLOCK_WROTE	RB	2	; The write request has completed.
EVENT_BLOCK_FORMATTED	RB	2	; The low-level format has completed.
EVENT_BLOCK_ERROR	RB	2

EVENT_FS_SIZE		RB	2
EVENT_FS_CREATED	RB	2
EVENT_FS_CHECKED	RB	2
EVENT_FS_DATA		RB	2	; The read request has succeeded.
EVENT_FS_WROTE		RB	2	; The write request has completed.
EVENT_FS_ERROR		RB	2

EVENT_FILE_NOT_FOUND	RB	2	; The file file was not found.
EVENT_FILE_OPENED	RB	2	; The file was successfully opened.
EVENT_FILE_DATA		RB	2	; The read request has succeeded.
EVENT_FILE_WROTE	RB	2	; The write request has completed.
EVENT_FILE_EOF		RB	2	; All file data has been read.
EVENT_FILE_CLOSED	RB	2	; The close request has completed.
EVENT_FILE_RENAMED	RB	2	; The rename request has completed.
EVENT_FILE_DELETED	RB	2	; The delete request has completed.
EVENT_FILE_ERROR	RB	2	; An error occured; close the file if opened.
EVENT_FILE_SEEK		RB	2	; The seek request has completed.

EVENT_DIR_OPENED	RB	2	; The directory open request succeeded.
EVENT_DIR_VOLUME	RB	2	; A volume record was found.
EVENT_DIR_FILE		RB	2	; A file record was found.
EVENT_DIR_FREE		RB	2	; A file-system free-space record was found.
EVENT_DIR_EOF		RB	2	; All data has been read.
EVENT_DIR_CLOSED	RB	2	; The directory file has been closed.
EVENT_DIR_ERROR		RB	2	; An error occured; user should close.
EVENT_DIR_CREATED	RB	2	; The directory has been created.
EVENT_DIR_DELETED	RB	2	; The directory has been deleted.

EVENT_NET_TCP		RB	2
EVENT_NET_UDP		RB	2

EVENT_CLOCK_TICK	RB	2


		RSRESET
event_type	RB	1	; Enum above
event_buf	RB	1	; page id or zero
event_ext	RB	1	; page id or zero
event_UNION	RB	0
event_SIZEOF	EQU	8	; events are 8 bytes

          ; Data in keyboard events
			RSSET	event_UNION
event_key_keyboard	RB	1	; Keyboard ID
event_key_raw		RB	1	; Raw key ID
event_key_ascii		RB	1	; ASCII value
event_key_flags		RB	1	; Flags (META)
EVENT_KEY_FLAG_META	EQU	$80	; Meta key; no associated ASCII value.

          ; Data in mouse events
			RSSET	event_UNION
event_mouse_delta_x	RB	1
event_mouse_delta_y	RB	1
event_mouse_delta_z	RB	1
event_mouse_delta_buttons RB	1

			RSSET	event_UNION
event_mouse_clicks_inner RB	1
event_mouse_clicks_middle RB	1
event_mouse_clicks_outer RB	1

			RSSET	event_UNION
event_joystick_joy0	RB	1
event_joystick_joy1	RB	1

          ; Data in file events:
			RSSET	event_UNION
event_file_stream	RB	1
event_file_cookie	RB	1
event_file_UNION	RB	0

			RSSET	event_file_UNION
			; ext contains disk id
event_file_data_requested RB	1   ; Requested number of bytes to read
event_file_data_read	RB	1   ; Number of bytes actually read

			RSSET	event_file_UNION
			; ext contains disk id
event_file_wrote_requested RB	1	; Requested number of bytes to read
event_file_wrote_wrote	RB	1	; Number of bytes actually read

          ; Data in directory events:
			RSSET	event_UNION
event_dir_stream	RB	1
event_dir_cookie	RB	1
event_dir_UNION		RB	0

			RSSET	event_dir_UNION
			; ext contains disk id
event_dir_vol_len	RB	1	; Length of volname (in buf)
event_dir_vol_flags	RB	1	; block size, text encoding

			RSSET	event_dir_UNION
			; ext contains byte count and modified date
event_dir_file_len	RB	1
event_dir_file_flags	RB	1	; block scale, text encoding, approx size

			RSSET	event_dir_UNION
			; ext contains byte count and modified date
event_dir_free_flags	RB	1	; block scale, text encoding, approx size

			RSRESET
			; Extended information; more to follow.
event_dir_ext_free	RB	6	; blocks used/free


          ; Data in net events (major changes coming)
			RSSET	event_UNION
event_udp_token		RB	1	; TODO: break out into fields

			RSSET	event_UNION
event_tcp_len		RB	1	; Raw packet length.
