Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43273 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752818AbYCVPb2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Mar 2008 11:31:28 -0400
Message-ID: <47E5264B.6000909@gmx.de> (sfid-20080322_153141_776490_789DE109)
Date: Sat, 22 Mar 2008 16:31:23 +0100
From: TT <fortt@gmx.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ipw2100: Fatal interrupt. Scheduling firmware restart.
Content-Type: multipart/mixed;
 boundary="------------070501000606060703090505"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070501000606060703090505
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

hi all,
i have some trouble with my wlan card (ipw2110).
In the irc channel #ipw i got the adress of the list.

my system:
- debian testing
- ipw fw 1.3
- ipw driver 1.2.2

if i try to connect with my router i got the message:
"ipw2100: Fatal interrupt. Scheduling firmware restart." and no connection.

Attached you find the dmesg output if i load the ipw module with
debug=0x43ff and try to establish a connection:

short overview:
###

ipw2100: Fatal interrupt. Scheduling firmware restart.
ipw2100: I ipw2100_irq_tasklet eth2: Fatal error value: 0x30016C44
ipw2100: I ipw2100_irq_tasklet eth2: Fatal error address value: 0x601F7C00
ipw2100: I schedule_reset eth2: Scheduling firmware restart (0s).
ipw2100: U ipw2100_reset_adapter : eth2: Restarting adapter.
ipw2100: U ipw2100_power_cycle_adapter Power cycling the hardware.

####

what can i do?
Maybe you can give me a tip?

Best regards
thomas


--------------070501000606060703090505
Content-Type: text/plain;
 name="debug_ipw.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="debug_ipw.txt"

ipw2100: U ipw2100_hw_send_command Sending HOST_COMPLETE command (#2), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'HOST_COMPLETE (2)'
ipw2100: U ipw2100_wx_set_essid ESSID set to current ESSID.
ipw2100: I isr_indicate_associated eth2: Associated with 'PRIVATE-->This is not for you!' at 11Mbps, channel 7 (BSSID=00:00:00:00:00:00)
ipw2100: Fatal interrupt. Scheduling firmware restart.
ipw2100: I ipw2100_irq_tasklet eth2: Fatal error value: 0x30016C44
ipw2100: I ipw2100_irq_tasklet eth2: Fatal error address value: 0x601F7C00
ipw2100: I schedule_reset eth2: Scheduling firmware restart (0s).
ipw2100: U ipw2100_reset_adapter : eth2: Restarting adapter.
ipw2100: U ipw2100_power_cycle_adapter Power cycling the hardware.
ipw2100: U ipw2100_start_adapter enter
ipw2100: U ipw2100_tx_initialize enter
ipw2100: U bd_queue_initialize enter
ipw2100: U bd_queue_initialize initializing bd queue at virt=c2379000, phys=02379000
ipw2100: U bd_queue_initialize exit
ipw2100: U ipw2100_tx_initialize exit
ipw2100: U ipw2100_rx_initialize enter
ipw2100: U bd_queue_initialize enter
ipw2100: U bd_queue_initialize initializing bd queue at virt=c2343000, phys=02343000
ipw2100: U bd_queue_initialize exit
ipw2100: U ipw2100_rx_initialize exit
ipw2100: U ipw2100_start_adapter exit
ipw2100: U ipw2100_initialize_ordinals enter
ipw2100: U ipw2100_initialize_ordinals table 1 size: 214
ipw2100: U ipw2100_initialize_ordinals table 2 size: 19
ipw2100: U ipw2100_initialize_ordinals exit
ipw2100: U ipw2100_get_hw_features EEPROM address: 0002B450
ipw2100: U ipw2100_get_hw_features EEPROM version: 3
ipw2100: U ipw2100_get_hw_features HW RF Kill: supported.
ipw2100: U ipw2100_adapter_setup enter
ipw2100: U ipw2100_disable_adapter CARD_DISABLE
ipw2100: U ipw2100_read_mac_address card MAC is 00:0C:F1:1F:8B:D0
ipw2100: U ipw2100_set_mac_address SET_MAC_ADDRESS
ipw2100: U ipw2100_set_mac_address enter
ipw2100: U ipw2100_hw_send_command Sending ADAPTER_ADDRESS command (#11), 6 bytes
ipw2100: I isr_rx_complete_command Command completed 'ADAPTER_ADDRESS (11)'
ipw2100: U ipw2100_set_mac_address exit
ipw2100: U ipw2100_set_port_type PORT_TYPE: Managed
ipw2100: U ipw2100_hw_send_command Sending PORT_TYPE command (#12), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'PORT_TYPE (12)'
ipw2100: U ipw2100_hw_send_command Sending SYSTEM_CONFIG command (#6), 12 bytes
ipw2100: I isr_rx_complete_command Command completed 'SYSTEM_CONFIG (6)'
ipw2100: U ipw2100_hw_send_command Sending BASIC_TX_RATES command (#19), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'BASIC_TX_RATES (19)'
ipw2100: U ipw2100_hw_send_command Sending TX_RATES command (#18), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'TX_RATES (18)'
ipw2100: U ipw2100_hw_send_command Sending MSDU_TX_RATESundefined command (#62), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'MSDU_TX_RATESundefined (62)'
ipw2100: U ipw2100_hw_send_command Sending POWER_MODE command (#17), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'POWER_MODE (17)'
ipw2100: U ipw2100_hw_send_command Sending RTS_THRESHOLD command (#15), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'RTS_THRESHOLD (15)'
ipw2100: U ipw2100_set_mandatory_bssid MANDATORY_BSSID: <clear>
ipw2100: U ipw2100_hw_send_command Sending MANDATORY_BSSID command (#9), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'MANDATORY_BSSID (9)'
ipw2100: U ipw2100_set_essid SSID: 'PRIVATE-->This is not for you!'
ipw2100: U ipw2100_hw_send_command Sending SSID command (#8), 30 bytes
ipw2100: I isr_rx_complete_command Command completed 'SSID (8)'
ipw2100: U ipw2100_set_security_information SET_SECURITY_INFORMATION: auth:0 cipher:0x22 (level 1)
ipw2100: U ipw2100_hw_send_command Sending SET_SECURITY_INFORMATION command (#67), 9 bytes
ipw2100: I isr_rx_complete_command Command completed 'SET_SECURITY_INFORMATION (67)'
ipw2100: U ipw2100_set_key_index WEP_KEY_INDEX: index = 0
ipw2100: U ipw2100_hw_send_command Sending WEP_KEY_INDEX command (#25), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'WEP_KEY_INDEX (25)'
ipw2100: U ipw2100_set_wep_flags WEP_FLAGS: flags = 0x00000008
ipw2100: U ipw2100_hw_send_command Sending WEP_FLAGS command (#26), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'WEP_FLAGS (26)'
ipw2100: U ipw2100_adapter_setup exit
ipw2100: U ipw2100_enable_adapter HOST_COMPLETE
ipw2100: U ipw2100_hw_send_command Sending HOST_COMPLETE command (#2), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'HOST_COMPLETE (2)'
ipw2100: U ipw2100_set_scan_options enter
ipw2100: U ipw2100_hw_send_command Sending SET_SCAN_OPTIONS command (#46), 8 bytes
ipw2100: I isr_rx_complete_command Command completed 'SET_SCAN_OPTIONS (46)'
ipw2100: U ipw2100_set_scan_options SET_SCAN_OPTIONS 0x0002
ipw2100: U ipw2100_start_scan START_SCAN
ipw2100: U ipw2100_wx_event_work enter
ipw2100: U ipw2100_wx_event_work Configuring ESSID
ipw2100: U ipw2100_set_essid SSID: 'PRIVATE-->This is not for you!'
ipw2100: U ipw2100_disable_adapter CARD_DISABLE
ipw2100: U ipw2100_hw_send_command Sending CARD_DISABLE command (#44), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'CARD_DISABLE (44)'
ipw2100: U ipw2100_disable_adapter TODO: implement scan state machine
ipw2100: U ipw2100_hw_send_command Sending SSID command (#8), 30 bytes
ipw2100: I isr_rx_complete_command Command completed 'SSID (8)'
ipw2100: U ipw2100_enable_adapter HOST_COMPLETE
ipw2100: U ipw2100_hw_send_command Sending HOST_COMPLETE command (#2), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'HOST_COMPLETE (2)'
ipw2100: U ipw2100_disable_adapter CARD_DISABLE
ipw2100: U ipw2100_hw_send_command Sending CARD_DISABLE command (#44), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'CARD_DISABLE (44)'
ipw2100: U ipw2100_disable_adapter TODO: implement scan state machine
ipw2100: U ipw2100_set_security_information SET_SECURITY_INFORMATION: auth:0 cipher:0x01 (level 0)
ipw2100: U ipw2100_hw_send_command Sending SET_SECURITY_INFORMATION command (#67), 9 bytes
ipw2100: I isr_rx_complete_command Command completed 'SET_SECURITY_INFORMATION (67)'
ipw2100: U ipw2100_set_wep_flags WEP_FLAGS: flags = 0x00000000
ipw2100: U ipw2100_hw_send_command Sending WEP_FLAGS command (#26), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'WEP_FLAGS (26)'
ipw2100: U ipw2100_enable_adapter HOST_COMPLETE
ipw2100: U ipw2100_hw_send_command Sending HOST_COMPLETE command (#2), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'HOST_COMPLETE (2)'
ipw2100: U ipw2100_disable_adapter CARD_DISABLE
ipw2100: U ipw2100_hw_send_command Sending CARD_DISABLE command (#44), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'CARD_DISABLE (44)'
ipw2100: U ipw2100_disable_adapter TODO: implement scan state machine
ipw2100: U ipw2100_set_security_information SET_SECURITY_INFORMATION: auth:0 cipher:0x01 (level 0)
ipw2100: U ipw2100_hw_send_command Sending SET_SECURITY_INFORMATION command (#67), 9 bytes
ipw2100: I isr_rx_complete_command Command completed 'SET_SECURITY_INFORMATION (67)'
ipw2100: U ipw2100_set_wep_flags WEP_FLAGS: flags = 0x00000000
ipw2100: U ipw2100_hw_send_command Sending WEP_FLAGS command (#26), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'WEP_FLAGS (26)'
ipw2100: U ipw2100_enable_adapter HOST_COMPLETE
ipw2100: U ipw2100_hw_send_command Sending HOST_COMPLETE command (#2), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'HOST_COMPLETE (2)'
ipw2100: U ipw2100_disable_adapter CARD_DISABLE
ipw2100: U ipw2100_hw_send_command Sending CARD_DISABLE command (#44), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'CARD_DISABLE (44)'
ipw2100: U ipw2100_disable_adapter TODO: implement scan state machine
ipw2100: U ipw2100_set_security_information SET_SECURITY_INFORMATION: auth:0 cipher:0x01 (level 0)
ipw2100: U ipw2100_hw_send_command Sending SET_SECURITY_INFORMATION command (#67), 9 bytes
ipw2100: I isr_rx_complete_command Command completed 'SET_SECURITY_INFORMATION (67)'
ipw2100: U ipw2100_set_wep_flags WEP_FLAGS: flags = 0x00000000
ipw2100: U ipw2100_hw_send_command Sending WEP_FLAGS command (#26), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'WEP_FLAGS (26)'
ipw2100: U ipw2100_enable_adapter HOST_COMPLETE
ipw2100: U ipw2100_hw_send_command Sending HOST_COMPLETE command (#2), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'HOST_COMPLETE (2)'
ipw2100: U ipw2100_disable_adapter CARD_DISABLE
ipw2100: U ipw2100_hw_send_command Sending CARD_DISABLE command (#44), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'CARD_DISABLE (44)'
ipw2100: U ipw2100_disable_adapter TODO: implement scan state machine
ipw2100: U ipw2100_set_security_information SET_SECURITY_INFORMATION: auth:0 cipher:0x01 (level 0)
ipw2100: U ipw2100_hw_send_command Sending SET_SECURITY_INFORMATION command (#67), 9 bytes
ipw2100: I isr_rx_complete_command Command completed 'SET_SECURITY_INFORMATION (67)'
ipw2100: U ipw2100_set_wep_flags WEP_FLAGS: flags = 0x00000000
ipw2100: U ipw2100_hw_send_command Sending WEP_FLAGS command (#26), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'WEP_FLAGS (26)'
ipw2100: U ipw2100_enable_adapter HOST_COMPLETE
ipw2100: U ipw2100_hw_send_command Sending HOST_COMPLETE command (#2), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'HOST_COMPLETE (2)'
ipw2100: U ipw2100_disable_adapter CARD_DISABLE
ipw2100: U ipw2100_hw_send_command Sending CARD_DISABLE command (#44), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'CARD_DISABLE (44)'
ipw2100: U ipw2100_disable_adapter TODO: implement scan state machine
ipw2100: U ipw2100_set_security_information SET_SECURITY_INFORMATION: auth:0 cipher:0x01 (level 0)
ipw2100: U ipw2100_hw_send_command Sending SET_SECURITY_INFORMATION command (#67), 9 bytes
ipw2100: I isr_rx_complete_command Command completed 'SET_SECURITY_INFORMATION (67)'
ipw2100: U ipw2100_set_wep_flags WEP_FLAGS: flags = 0x00000000
ipw2100: U ipw2100_hw_send_command Sending WEP_FLAGS command (#26), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'WEP_FLAGS (26)'
ipw2100: U ipw2100_enable_adapter HOST_COMPLETE
ipw2100: U ipw2100_hw_send_command Sending HOST_COMPLETE command (#2), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'HOST_COMPLETE (2)'
ipw2100: U ipw2100_wx_set_scan Initiating scan...
ipw2100: U ipw2100_set_scan_options enter
ipw2100: U ipw2100_hw_send_command Sending SET_SCAN_OPTIONS command (#46), 8 bytes
ipw2100: I isr_rx_complete_command Command completed 'SET_SCAN_OPTIONS (46)'
ipw2100: U ipw2100_set_scan_options SET_SCAN_OPTIONS 0x0000
ipw2100: U ipw2100_start_scan START_SCAN
ipw2100: U ipw2100_start_scan enter
ipw2100: U ipw2100_hw_send_command Sending BROADCAST_SCAN command (#43), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'BROADCAST_SCAN (43)'
ipw2100: U ipw2100_start_scan exit
ipw2100: U ipw2100_disable_adapter CARD_DISABLE
ipw2100: U ipw2100_hw_send_command Sending CARD_DISABLE command (#44), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'CARD_DISABLE (44)'
ipw2100: U ipw2100_disable_adapter TODO: implement scan state machine
ipw2100: U ipw2100_set_security_information SET_SECURITY_INFORMATION: auth:0 cipher:0x01 (level 0)
ipw2100: U ipw2100_hw_send_command Sending SET_SECURITY_INFORMATION command (#67), 9 bytes
ipw2100: I isr_rx_complete_command Command completed 'SET_SECURITY_INFORMATION (67)'
ipw2100: U ipw2100_set_wep_flags WEP_FLAGS: flags = 0x00000000
ipw2100: U ipw2100_hw_send_command Sending WEP_FLAGS command (#26), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'WEP_FLAGS (26)'
ipw2100: U ipw2100_enable_adapter HOST_COMPLETE
ipw2100: U ipw2100_hw_send_command Sending HOST_COMPLETE command (#2), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'HOST_COMPLETE (2)'
ipw2100: U ipw2100_disable_adapter CARD_DISABLE
ipw2100: U ipw2100_hw_send_command Sending CARD_DISABLE command (#44), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'CARD_DISABLE (44)'
ipw2100: U ipw2100_disable_adapter TODO: implement scan state machine
ipw2100: U ipw2100_set_security_information SET_SECURITY_INFORMATION: auth:0 cipher:0x22 (level 1)
ipw2100: U ipw2100_hw_send_command Sending SET_SECURITY_INFORMATION command (#67), 9 bytes
ipw2100: I isr_rx_complete_command Command completed 'SET_SECURITY_INFORMATION (67)'
ipw2100: U ipw2100_set_key_index WEP_KEY_INDEX: index = 0
ipw2100: U ipw2100_hw_send_command Sending WEP_KEY_INDEX command (#25), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'WEP_KEY_INDEX (25)'
ipw2100: U ipw2100_set_wep_flags WEP_FLAGS: flags = 0x00000008
ipw2100: U ipw2100_hw_send_command Sending WEP_FLAGS command (#26), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'WEP_FLAGS (26)'
ipw2100: U ipw2100_enable_adapter HOST_COMPLETE
ipw2100: U ipw2100_hw_send_command Sending HOST_COMPLETE command (#2), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'HOST_COMPLETE (2)'
ipw2100: U ipw2100_wx_set_wap exit - disable mandatory BSSID
ipw2100: U ipw2100_set_mandatory_bssid MANDATORY_BSSID: <clear>
ipw2100: U ipw2100_disable_adapter CARD_DISABLE
ipw2100: U ipw2100_hw_send_command Sending CARD_DISABLE command (#44), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'CARD_DISABLE (44)'
ipw2100: U ipw2100_disable_adapter TODO: implement scan state machine
ipw2100: U ipw2100_hw_send_command Sending MANDATORY_BSSID command (#9), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'MANDATORY_BSSID (9)'
ipw2100: U ipw2100_enable_adapter HOST_COMPLETE
ipw2100: U ipw2100_hw_send_command Sending HOST_COMPLETE command (#2), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'HOST_COMPLETE (2)'
ipw2100: U ipw2100_wx_set_mode SET Mode -> 2 
ipw2100: U ipw2100_set_wpa_ie SET_WPA_IE
ipw2100: U ipw2100_disable_adapter CARD_DISABLE
ipw2100: U ipw2100_hw_send_command Sending CARD_DISABLE command (#44), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'CARD_DISABLE (44)'
ipw2100: U ipw2100_disable_adapter TODO: implement scan state machine
ipw2100: U ipw2100_hw_send_command Sending SET_WPA_ASS_IE command (#69), 400 bytes
ipw2100: I isr_rx_complete_command Command completed 'SET_WPA_ASS_IE (69)'
ipw2100: U ipw2100_enable_adapter HOST_COMPLETE
ipw2100: U ipw2100_hw_send_command Sending HOST_COMPLETE command (#2), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'HOST_COMPLETE (2)'
ipw2100: U ipw2100_wx_set_essid ESSID set to current ESSID.
ipw2100: I isr_indicate_associated eth2: Associated with 'PRIVATE-->This is not for you!' at 11Mbps, channel 7 (BSSID=00:00:00:00:00:00)
ipw2100: Fatal interrupt. Scheduling firmware restart.
ipw2100: I ipw2100_irq_tasklet eth2: Fatal error value: 0x30016C44
ipw2100: I ipw2100_irq_tasklet eth2: Fatal error address value: 0x601F7C00
ipw2100: I schedule_reset eth2: Scheduling firmware restart (0s).
ipw2100: U ipw2100_reset_adapter : eth2: Restarting adapter.
ipw2100: U ipw2100_power_cycle_adapter Power cycling the hardware.
ipw2100: U ipw2100_start_adapter enter
ipw2100: U ipw2100_tx_initialize enter
ipw2100: U bd_queue_initialize enter
ipw2100: U bd_queue_initialize initializing bd queue at virt=c2379000, phys=02379000
ipw2100: U bd_queue_initialize exit
ipw2100: U ipw2100_tx_initialize exit
ipw2100: U ipw2100_rx_initialize enter
ipw2100: U bd_queue_initialize enter
ipw2100: U bd_queue_initialize initializing bd queue at virt=c2343000, phys=02343000
ipw2100: U bd_queue_initialize exit
ipw2100: U ipw2100_rx_initialize exit
ipw2100: U ipw2100_start_adapter exit
ipw2100: U ipw2100_initialize_ordinals enter
ipw2100: U ipw2100_initialize_ordinals table 1 size: 214
ipw2100: U ipw2100_initialize_ordinals table 2 size: 19
ipw2100: U ipw2100_initialize_ordinals exit
ipw2100: U ipw2100_get_hw_features EEPROM address: 0002B450
ipw2100: U ipw2100_get_hw_features EEPROM version: 3
ipw2100: U ipw2100_get_hw_features HW RF Kill: supported.
ipw2100: U ipw2100_adapter_setup enter
ipw2100: U ipw2100_disable_adapter CARD_DISABLE
ipw2100: U ipw2100_read_mac_address card MAC is 00:0C:F1:1F:8B:D0
ipw2100: U ipw2100_set_mac_address SET_MAC_ADDRESS
ipw2100: U ipw2100_set_mac_address enter
ipw2100: U ipw2100_hw_send_command Sending ADAPTER_ADDRESS command (#11), 6 bytes
ipw2100: I isr_rx_complete_command Command completed 'ADAPTER_ADDRESS (11)'
ipw2100: U ipw2100_set_mac_address exit
ipw2100: U ipw2100_set_port_type PORT_TYPE: Managed
ipw2100: U ipw2100_hw_send_command Sending PORT_TYPE command (#12), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'PORT_TYPE (12)'
ipw2100: U ipw2100_hw_send_command Sending SYSTEM_CONFIG command (#6), 12 bytes
ipw2100: I isr_rx_complete_command Command completed 'SYSTEM_CONFIG (6)'
ipw2100: U ipw2100_hw_send_command Sending BASIC_TX_RATES command (#19), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'BASIC_TX_RATES (19)'
ipw2100: U ipw2100_hw_send_command Sending TX_RATES command (#18), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'TX_RATES (18)'
ipw2100: U ipw2100_hw_send_command Sending MSDU_TX_RATESundefined command (#62), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'MSDU_TX_RATESundefined (62)'
ipw2100: U ipw2100_hw_send_command Sending POWER_MODE command (#17), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'POWER_MODE (17)'
ipw2100: U ipw2100_hw_send_command Sending RTS_THRESHOLD command (#15), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'RTS_THRESHOLD (15)'
ipw2100: U ipw2100_set_mandatory_bssid MANDATORY_BSSID: <clear>
ipw2100: U ipw2100_hw_send_command Sending MANDATORY_BSSID command (#9), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'MANDATORY_BSSID (9)'
ipw2100: U ipw2100_set_essid SSID: 'PRIVATE-->This is not for you!'
ipw2100: U ipw2100_hw_send_command Sending SSID command (#8), 30 bytes
ipw2100: I isr_rx_complete_command Command completed 'SSID (8)'
ipw2100: U ipw2100_set_security_information SET_SECURITY_INFORMATION: auth:0 cipher:0x22 (level 1)
ipw2100: U ipw2100_hw_send_command Sending SET_SECURITY_INFORMATION command (#67), 9 bytes
ipw2100: I isr_rx_complete_command Command completed 'SET_SECURITY_INFORMATION (67)'
ipw2100: U ipw2100_set_key_index WEP_KEY_INDEX: index = 0
ipw2100: U ipw2100_hw_send_command Sending WEP_KEY_INDEX command (#25), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'WEP_KEY_INDEX (25)'
ipw2100: U ipw2100_set_wep_flags WEP_FLAGS: flags = 0x00000008
ipw2100: U ipw2100_hw_send_command Sending WEP_FLAGS command (#26), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'WEP_FLAGS (26)'
ipw2100: U ipw2100_adapter_setup exit
ipw2100: U ipw2100_enable_adapter HOST_COMPLETE
ipw2100: U ipw2100_hw_send_command Sending HOST_COMPLETE command (#2), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'HOST_COMPLETE (2)'
ipw2100: U ipw2100_set_scan_options enter
ipw2100: U ipw2100_hw_send_command Sending SET_SCAN_OPTIONS command (#46), 8 bytes
ipw2100: I isr_rx_complete_command Command completed 'SET_SCAN_OPTIONS (46)'
ipw2100: U ipw2100_set_scan_options SET_SCAN_OPTIONS 0x0002
ipw2100: U ipw2100_start_scan START_SCAN
ipw2100: U ipw2100_wx_event_work enter
ipw2100: U ipw2100_wx_event_work Configuring ESSID
ipw2100: U ipw2100_set_essid SSID: 'PRIVATE-->This is not for you!'
ipw2100: U ipw2100_disable_adapter CARD_DISABLE
ipw2100: U ipw2100_hw_send_command Sending CARD_DISABLE command (#44), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'CARD_DISABLE (44)'
ipw2100: U ipw2100_disable_adapter TODO: implement scan state machine
ipw2100: U ipw2100_hw_send_command Sending SSID command (#8), 30 bytes
ipw2100: I isr_rx_complete_command Command completed 'SSID (8)'
ipw2100: U ipw2100_enable_adapter HOST_COMPLETE
ipw2100: U ipw2100_hw_send_command Sending HOST_COMPLETE command (#2), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'HOST_COMPLETE (2)'
ipw2100: U ipw2100_disable_adapter CARD_DISABLE
ipw2100: U ipw2100_hw_send_command Sending CARD_DISABLE command (#44), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'CARD_DISABLE (44)'
ipw2100: U ipw2100_disable_adapter TODO: implement scan state machine
ipw2100: U ipw2100_set_security_information SET_SECURITY_INFORMATION: auth:0 cipher:0x01 (level 0)
ipw2100: U ipw2100_hw_send_command Sending SET_SECURITY_INFORMATION command (#67), 9 bytes
ipw2100: I isr_rx_complete_command Command completed 'SET_SECURITY_INFORMATION (67)'
ipw2100: U ipw2100_set_wep_flags WEP_FLAGS: flags = 0x00000000
ipw2100: U ipw2100_hw_send_command Sending WEP_FLAGS command (#26), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'WEP_FLAGS (26)'
ipw2100: U ipw2100_enable_adapter HOST_COMPLETE
ipw2100: U ipw2100_hw_send_command Sending HOST_COMPLETE command (#2), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'HOST_COMPLETE (2)'
ipw2100: U ipw2100_disable_adapter CARD_DISABLE
ipw2100: U ipw2100_hw_send_command Sending CARD_DISABLE command (#44), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'CARD_DISABLE (44)'
ipw2100: U ipw2100_disable_adapter TODO: implement scan state machine
ipw2100: U ipw2100_set_security_information SET_SECURITY_INFORMATION: auth:0 cipher:0x01 (level 0)
ipw2100: U ipw2100_hw_send_command Sending SET_SECURITY_INFORMATION command (#67), 9 bytes
ipw2100: I isr_rx_complete_command Command completed 'SET_SECURITY_INFORMATION (67)'
ipw2100: U ipw2100_set_wep_flags WEP_FLAGS: flags = 0x00000000
ipw2100: U ipw2100_hw_send_command Sending WEP_FLAGS command (#26), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'WEP_FLAGS (26)'
ipw2100: U ipw2100_enable_adapter HOST_COMPLETE
ipw2100: U ipw2100_hw_send_command Sending HOST_COMPLETE command (#2), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'HOST_COMPLETE (2)'
ipw2100: U ipw2100_disable_adapter CARD_DISABLE
ipw2100: U ipw2100_hw_send_command Sending CARD_DISABLE command (#44), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'CARD_DISABLE (44)'
ipw2100: U ipw2100_disable_adapter TODO: implement scan state machine
ipw2100: U ipw2100_set_security_information SET_SECURITY_INFORMATION: auth:0 cipher:0x01 (level 0)
ipw2100: U ipw2100_hw_send_command Sending SET_SECURITY_INFORMATION command (#67), 9 bytes
ipw2100: I isr_rx_complete_command Command completed 'SET_SECURITY_INFORMATION (67)'
ipw2100: U ipw2100_set_wep_flags WEP_FLAGS: flags = 0x00000000
ipw2100: U ipw2100_hw_send_command Sending WEP_FLAGS command (#26), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'WEP_FLAGS (26)'
ipw2100: U ipw2100_enable_adapter HOST_COMPLETE
ipw2100: U ipw2100_hw_send_command Sending HOST_COMPLETE command (#2), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'HOST_COMPLETE (2)'
ipw2100: U ipw2100_disable_adapter CARD_DISABLE
ipw2100: U ipw2100_hw_send_command Sending CARD_DISABLE command (#44), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'CARD_DISABLE (44)'
ipw2100: U ipw2100_disable_adapter TODO: implement scan state machine
ipw2100: U ipw2100_set_security_information SET_SECURITY_INFORMATION: auth:0 cipher:0x01 (level 0)
ipw2100: U ipw2100_hw_send_command Sending SET_SECURITY_INFORMATION command (#67), 9 bytes
ipw2100: I isr_rx_complete_command Command completed 'SET_SECURITY_INFORMATION (67)'
ipw2100: U ipw2100_set_wep_flags WEP_FLAGS: flags = 0x00000000
ipw2100: U ipw2100_hw_send_command Sending WEP_FLAGS command (#26), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'WEP_FLAGS (26)'
ipw2100: U ipw2100_enable_adapter HOST_COMPLETE
ipw2100: U ipw2100_hw_send_command Sending HOST_COMPLETE command (#2), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'HOST_COMPLETE (2)'
ipw2100: U ipw2100_disable_adapter CARD_DISABLE
ipw2100: U ipw2100_hw_send_command Sending CARD_DISABLE command (#44), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'CARD_DISABLE (44)'
ipw2100: U ipw2100_disable_adapter TODO: implement scan state machine
ipw2100: U ipw2100_set_security_information SET_SECURITY_INFORMATION: auth:0 cipher:0x01 (level 0)
ipw2100: U ipw2100_hw_send_command Sending SET_SECURITY_INFORMATION command (#67), 9 bytes
ipw2100: I isr_rx_complete_command Command completed 'SET_SECURITY_INFORMATION (67)'
ipw2100: U ipw2100_set_wep_flags WEP_FLAGS: flags = 0x00000000
ipw2100: U ipw2100_hw_send_command Sending WEP_FLAGS command (#26), 4 bytes
ipw2100: I isr_rx_complete_command Command completed 'WEP_FLAGS (26)'
ipw2100: U ipw2100_enable_adapter HOST_COMPLETE
ipw2100: U ipw2100_hw_send_command Sending HOST_COMPLETE command (#2), 0 bytes
ipw2100: I isr_rx_complete_command Command completed 'HOST_COMPLETE (2)'

--------------070501000606060703090505--
