Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.neti.ee ([194.126.126.37]:57015 "EHLO smtp-out.neti.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbYHMIDW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2008 04:03:22 -0400
Received: from smtp-out.neti.ee (unknown [88.196.174.136])
	by HOT-Bounce1.estpak.ee (Postfix) with ESMTP id 556C789FD28
	for <linux-wireless@vger.kernel.org>; Wed, 13 Aug 2008 10:52:02 +0300 (EEST)
Received: from localhost (localhost [127.0.0.1])
	by MXR-5.estpak.ee (Postfix) with ESMTP id A265D1DE2CA
	for <linux-wireless@vger.kernel.org>; Wed, 13 Aug 2008 10:48:55 +0300 (EEST)
Received: from smtp-out.neti.ee ([127.0.0.1])
	by localhost (MXR-5.estpak.ee [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JiNY9pT1Y5Ud for <linux-wireless@vger.kernel.org>;
	Wed, 13 Aug 2008 10:48:52 +0300 (EEST)
Received: from Relayhost1.neti.ee (Relayhost1 [88.196.174.141])
	by MXR-5.estpak.ee (Postfix) with ESMTP id B41DA1DE882
	for <linux-wireless@vger.kernel.org>; Wed, 13 Aug 2008 10:48:52 +0300 (EEST)
Subject: Question
From: Artjom <engine80@bk.ru>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Wed, 13 Aug 2008 10:48:50 +0300
Message-Id: <1218613730.11607.8.camel@localhost.localdomain> (sfid-20080813_100332_708168_28E05F23)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No possible to load compat-wireless modules in Fedora 8. What to do?
What is the reason?
The same with kernel 2.6.26.2-2.fc8.
                                               Best regards.
                                                     Artjom.

[root@localhost compat-wireless-2008-08-06]# make load
Loading ipw2100...
Loading ipw2200...
Loading libertas_cs...
Loading usb8xxx...
Loading p54pci...
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting p54common
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/p54/p54common.ko): Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting p54pci
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/p54/p54pci.ko): Unknown symbol in module, or unknown parameter (see dmesg)
Loading p54usb...
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting p54common
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/p54/p54common.ko): Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting p54usb
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/p54/p54usb.ko): Unknown symbol in module, or unknown parameter (see dmesg)
Loading adm8211...
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting adm8211
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/adm8211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
Loading zd1211rw...
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting zd1211rw
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/zd1211rw/zd1211rw.ko): Unknown symbol in module, or unknown parameter (see dmesg)
Loading rtl8180...
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting rtl8180
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/rtl8180.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
Loading rtl8187...
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting rtl8187
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/rtl8187.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
Loading p54pci...
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting p54common
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/p54/p54common.ko): Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting p54pci
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/p54/p54pci.ko): Unknown symbol in module, or unknown parameter (see dmesg)
Loading p54usb...
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting p54common
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/p54/p54common.ko): Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting p54usb
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/p54/p54usb.ko): Unknown symbol in module, or unknown parameter (see dmesg)
Loading iwl3945...
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting iwl3945
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/iwlwifi/iwl3945.ko): Unknown symbol in module, or unknown parameter (see dmesg)
Loading iwl4965...
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting iwlcore
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/iwlwifi/iwlcore.ko): Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting iwl4965
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/iwlwifi/iwl4965.ko): Unknown symbol in module, or unknown parameter (see dmesg)
Loading rtl8180...
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting rtl8180
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/rtl8180.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
Loading rtl8187...
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting rtl8187
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/rtl8187.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
Loading rtl8180...
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting rtl8180
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/rtl8180.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
Loading rtl8187...
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting rtl8187
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/rtl8187.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
Loading rt2400pci...
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting rt2x00lib
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/rt2x00/rt2x00lib.ko): Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting rt2x00pci
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/rt2x00/rt2x00pci.ko): Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting rt2400pci
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/rt2x00/rt2400pci.ko): Unknown symbol in module, or unknown parameter (see dmesg)
Loading rt2500pci...
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting rt2x00lib
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/rt2x00/rt2x00lib.ko): Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting rt2x00pci
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/rt2x00/rt2x00pci.ko): Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting rt2500pci
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/rt2x00/rt2500pci.ko): Unknown symbol in module, or unknown parameter (see dmesg)
Loading rt61pci...
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting rt2x00lib
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/rt2x00/rt2x00lib.ko): Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting rt2x00pci
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/rt2x00/rt2x00pci.ko): Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting rt61pci
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/rt2x00/rt61pci.ko): Unknown symbol in module, or unknown parameter (see dmesg)
Loading rt2500usb...
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting rt2x00lib
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/rt2x00/rt2x00lib.ko): Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting rt2x00usb
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/rt2x00/rt2x00usb.ko): Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting rt2500usb
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/rt2x00/rt2500usb.ko): Unknown symbol in module, or unknown parameter (see dmesg)
Loading rt73usb...
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting rt2x00lib
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/rt2x00/rt2x00lib.ko): Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting rt2x00usb
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/rt2x00/rt2x00usb.ko): Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting rt73usb
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/rt2x00/rt73usb.ko): Unknown symbol in module, or unknown parameter (see dmesg)
Loading rndis_wlan...
Loading at76_usb...
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting at76_usb
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/at76_usb.ko): Unknown symbol in module, or unknown parameter (see dmesg)
Module ath_pci not detected -- this is fine
Enabling ath5k ...      [OK]    Module renamed but another module file
is being preferred
Renamed
module:         /lib/modules/2.6.25.14-69.fc8/kernel/drivers/net/wireless/ath5k/ath5k.ko
Preferred
module:       /lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/ath5k/ath5k.ko
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting ath5k
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/ath5k/ath5k.ko): Unknown symbol in module, or unknown parameter (see dmesg)
ath5k loaded successfully
Module bcm43xx not detected -- this is fine
Enabling b43 ...        [OK]    Module renamed but another module file
is being preferred
Renamed
module:         /lib/modules/2.6.25.14-69.fc8/kernel/drivers/net/wireless/b43/b43.ko
Preferred
module:       /lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/b43/b43.ko
Enabling b43legacy ...  [OK]    Module renamed but another module file
is being preferred
Renamed
module:         /lib/modules/2.6.25.14-69.fc8/kernel/drivers/net/wireless/b43legacy/b43legacy.ko
Preferred
module:       /lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/b43legacy/b43legacy.ko
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting b43
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/b43/b43.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting b43legacy
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/b43legacy/b43legacy.ko): Unknown symbol in module, or unknown parameter (see dmesg)
b43 loaded successfully
b43legacy loaded successfully

[root@localhost compat-wireless-2008-08-06]# dmesg -c
mac80211: Unknown symbol wiphy_new
mac80211: Unknown symbol wiphy_unregister
mac80211: Unknown symbol ieee80211_radiotap_iterator_init
mac80211: Unknown symbol __ieee80211_get_channel
mac80211: Unknown symbol ieee80211_radiotap_iterator_next
mac80211: Unknown symbol ieee80211_channel_to_frequency
mac80211: Unknown symbol ieee80211_frequency_to_channel
mac80211: Unknown symbol wiphy_free
rtl8180: Unknown symbol ieee80211_free_hw
rtl8180: Unknown symbol ieee80211_alloc_hw
rtl8180: Unknown symbol ieee80211_register_hw
rtl8180: Unknown symbol ieee80211_wake_queue
rtl8180: Unknown symbol ieee80211_tx_status_irqsafe
rtl8180: Unknown symbol ieee80211_stop_queue
rtl8180: Unknown symbol ieee80211_unregister_hw
rtl8180: Unknown symbol ieee80211_frequency_to_channel
rtl8180: Unknown symbol ieee80211_rx_irqsafe
rtl8180: Unknown symbol ieee80211_rts_duration
cfg80211: exports duplicate symbol rfkill_force_state (owned by rfkill)
mac80211: Unknown symbol wiphy_register
mac80211: Unknown symbol wiphy_new
mac80211: Unknown symbol wiphy_unregister
mac80211: Unknown symbol ieee80211_radiotap_iterator_init
mac80211: Unknown symbol __ieee80211_get_channel
mac80211: Unknown symbol ieee80211_radiotap_iterator_next
mac80211: Unknown symbol ieee80211_channel_to_frequency
mac80211: Unknown symbol ieee80211_frequency_to_channel
mac80211: Unknown symbol wiphy_free
rtl8187: Unknown symbol ieee80211_free_hw
rtl8187: Unknown symbol ieee80211_alloc_hw
rtl8187: Unknown symbol ieee80211_register_hw
rtl8187: Unknown symbol ieee80211_generic_frame_duration
rtl8187: Unknown symbol ieee80211_tx_status_irqsafe
rtl8187: Unknown symbol ieee80211_unregister_hw
rtl8187: Unknown symbol ieee80211_frequency_to_channel
rtl8187: Unknown symbol ieee80211_rx_irqsafe
rtl8187: Unknown symbol ieee80211_rts_duration
cfg80211: exports duplicate symbol rfkill_force_state (owned by rfkill)
mac80211: Unknown symbol wiphy_register
mac80211: Unknown symbol wiphy_new
mac80211: Unknown symbol wiphy_unregister
mac80211: Unknown symbol ieee80211_radiotap_iterator_init
mac80211: Unknown symbol __ieee80211_get_channel
mac80211: Unknown symbol ieee80211_radiotap_iterator_next
mac80211: Unknown symbol ieee80211_channel_to_frequency
mac80211: Unknown symbol ieee80211_frequency_to_channel
mac80211: Unknown symbol wiphy_free
rtl8180: Unknown symbol ieee80211_free_hw
rtl8180: Unknown symbol ieee80211_alloc_hw
rtl8180: Unknown symbol ieee80211_register_hw
rtl8180: Unknown symbol ieee80211_wake_queue
rtl8180: Unknown symbol ieee80211_tx_status_irqsafe
rtl8180: Unknown symbol ieee80211_stop_queue
rtl8180: Unknown symbol ieee80211_unregister_hw
rtl8180: Unknown symbol ieee80211_frequency_to_channel
rtl8180: Unknown symbol ieee80211_rx_irqsafe
rtl8180: Unknown symbol ieee80211_rts_duration
cfg80211: exports duplicate symbol rfkill_force_state (owned by rfkill)
mac80211: Unknown symbol wiphy_register
mac80211: Unknown symbol wiphy_new
mac80211: Unknown symbol wiphy_unregister
mac80211: Unknown symbol ieee80211_radiotap_iterator_init
mac80211: Unknown symbol __ieee80211_get_channel
mac80211: Unknown symbol ieee80211_radiotap_iterator_next
mac80211: Unknown symbol ieee80211_channel_to_frequency
mac80211: Unknown symbol ieee80211_frequency_to_channel
mac80211: Unknown symbol wiphy_free
rtl8187: Unknown symbol ieee80211_free_hw
rtl8187: Unknown symbol ieee80211_alloc_hw
rtl8187: Unknown symbol ieee80211_register_hw
rtl8187: Unknown symbol ieee80211_generic_frame_duration
rtl8187: Unknown symbol ieee80211_tx_status_irqsafe
rtl8187: Unknown symbol ieee80211_unregister_hw
rtl8187: Unknown symbol ieee80211_frequency_to_channel
rtl8187: Unknown symbol ieee80211_rx_irqsafe
rtl8187: Unknown symbol ieee80211_rts_duration
cfg80211: exports duplicate symbol rfkill_force_state (owned by rfkill)
mac80211: Unknown symbol wiphy_register
mac80211: Unknown symbol wiphy_new
mac80211: Unknown symbol wiphy_unregister
mac80211: Unknown symbol ieee80211_radiotap_iterator_init
mac80211: Unknown symbol __ieee80211_get_channel
mac80211: Unknown symbol ieee80211_radiotap_iterator_next
mac80211: Unknown symbol ieee80211_channel_to_frequency
mac80211: Unknown symbol ieee80211_frequency_to_channel
mac80211: Unknown symbol wiphy_free
rt2x00lib: Unknown symbol ieee80211_register_hw
rt2x00lib: Unknown symbol ieee80211_get_hdrlen_from_skb
rt2x00lib: Unknown symbol ieee80211_wake_queue
rt2x00lib: Unknown symbol ieee80211_tx_status_irqsafe
rt2x00lib: Unknown symbol ieee80211_ctstoself_get
rt2x00lib: Unknown symbol ieee80211_wake_queues
rt2x00lib: Unknown symbol ieee80211_iterate_active_interfaces
rt2x00lib: Unknown symbol ieee80211_stop_queue
rt2x00lib: Unknown symbol ieee80211_stop_queues
rt2x00lib: Unknown symbol ieee80211_iterate_active_interfaces_atomic
rt2x00lib: Unknown symbol ieee80211_channel_to_frequency
rt2x00lib: Unknown symbol ieee80211_unregister_hw
rt2x00lib: Unknown symbol ieee80211_rts_get
rt2x00lib: Unknown symbol ieee80211_beacon_get
rt2x00lib: Unknown symbol ieee80211_rx_irqsafe
rt2x00pci: Unknown symbol rt2x00lib_suspend
rt2x00pci: Unknown symbol rt2x00lib_probe_dev
rt2x00pci: Unknown symbol ieee80211_free_hw
rt2x00pci: Unknown symbol ieee80211_alloc_hw
rt2x00pci: Unknown symbol rt2x00lib_rxdone
rt2x00pci: Unknown symbol rt2x00queue_get_entry
rt2x00pci: Unknown symbol rt2x00lib_remove_dev
rt2x00pci: Unknown symbol rt2x00lib_resume
rt2400pci: Unknown symbol rt2x00mac_add_interface
rt2400pci: Unknown symbol rt2x00queue_map_txskb
rt2400pci: Unknown symbol rt2x00mac_get_stats
rt2400pci: Unknown symbol rt2x00pci_initialize
rt2400pci: Unknown symbol rt2x00pci_uninitialize
rt2400pci: Unknown symbol rt2x00queue_get_entry
rt2400pci: Unknown symbol rt2x00pci_suspend
rt2400pci: Unknown symbol rt2x00mac_config_interface
rt2400pci: Unknown symbol rt2x00pci_remove
rt2400pci: Unknown symbol rt2x00mac_remove_interface
rt2400pci: Unknown symbol rt2x00lib_txdone
rt2400pci: Unknown symbol rt2x00mac_config
rt2400pci: Unknown symbol rt2x00queue_get_queue
rt2400pci: Unknown symbol rt2x00mac_conf_tx
rt2400pci: Unknown symbol rt2x00mac_start
rt2400pci: Unknown symbol rt2x00mac_stop
rt2400pci: Unknown symbol rt2x00mac_configure_filter
rt2400pci: Unknown symbol rt2x00mac_tx
rt2400pci: Unknown symbol rt2x00pci_resume
rt2400pci: Unknown symbol rt2x00pci_probe
rt2400pci: Unknown symbol rt2x00mac_get_tx_stats
rt2400pci: Unknown symbol rt2x00pci_rxdone
rt2400pci: Unknown symbol rt2x00lib_beacondone
rt2400pci: Unknown symbol rt2x00mac_bss_info_changed
rt2400pci: Unknown symbol rt2x00pci_write_tx_data
cfg80211: exports duplicate symbol rfkill_force_state (owned by rfkill)
mac80211: Unknown symbol wiphy_register
mac80211: Unknown symbol wiphy_new
mac80211: Unknown symbol wiphy_unregister
mac80211: Unknown symbol ieee80211_radiotap_iterator_init
mac80211: Unknown symbol __ieee80211_get_channel
mac80211: Unknown symbol ieee80211_radiotap_iterator_next
mac80211: Unknown symbol ieee80211_channel_to_frequency
mac80211: Unknown symbol ieee80211_frequency_to_channel
mac80211: Unknown symbol wiphy_free
rt2x00lib: Unknown symbol ieee80211_register_hw
rt2x00lib: Unknown symbol ieee80211_get_hdrlen_from_skb
rt2x00lib: Unknown symbol ieee80211_wake_queue
rt2x00lib: Unknown symbol ieee80211_tx_status_irqsafe
rt2x00lib: Unknown symbol ieee80211_ctstoself_get
rt2x00lib: Unknown symbol ieee80211_wake_queues
rt2x00lib: Unknown symbol ieee80211_iterate_active_interfaces
rt2x00lib: Unknown symbol ieee80211_stop_queue
rt2x00lib: Unknown symbol ieee80211_stop_queues
rt2x00lib: Unknown symbol ieee80211_iterate_active_interfaces_atomic
rt2x00lib: Unknown symbol ieee80211_channel_to_frequency
rt2x00lib: Unknown symbol ieee80211_unregister_hw
rt2x00lib: Unknown symbol ieee80211_rts_get
rt2x00lib: Unknown symbol ieee80211_beacon_get
rt2x00lib: Unknown symbol ieee80211_rx_irqsafe
rt2x00pci: Unknown symbol rt2x00lib_suspend
rt2x00pci: Unknown symbol rt2x00lib_probe_dev
rt2x00pci: Unknown symbol ieee80211_free_hw
rt2x00pci: Unknown symbol ieee80211_alloc_hw
rt2x00pci: Unknown symbol rt2x00lib_rxdone
rt2x00pci: Unknown symbol rt2x00queue_get_entry
rt2x00pci: Unknown symbol rt2x00lib_remove_dev
rt2x00pci: Unknown symbol rt2x00lib_resume
rt2500pci: Unknown symbol rt2x00mac_add_interface
rt2500pci: Unknown symbol rt2x00queue_map_txskb
rt2500pci: Unknown symbol rt2x00mac_get_stats
rt2500pci: Unknown symbol rt2x00pci_initialize
rt2500pci: Unknown symbol rt2x00pci_uninitialize
rt2500pci: Unknown symbol rt2x00queue_get_entry
rt2500pci: Unknown symbol rt2x00pci_suspend
rt2500pci: Unknown symbol rt2x00mac_config_interface
rt2500pci: Unknown symbol rt2x00pci_remove
rt2500pci: Unknown symbol rt2x00mac_remove_interface
rt2500pci: Unknown symbol rt2x00lib_txdone
rt2500pci: Unknown symbol rt2x00mac_config
rt2500pci: Unknown symbol rt2x00queue_get_queue
rt2500pci: Unknown symbol rt2x00mac_conf_tx
rt2500pci: Unknown symbol rt2x00mac_start
rt2500pci: Unknown symbol rt2x00mac_stop
rt2500pci: Unknown symbol rt2x00mac_configure_filter
rt2500pci: Unknown symbol rt2x00mac_tx
rt2500pci: Unknown symbol rt2x00pci_resume
rt2500pci: Unknown symbol rt2x00pci_probe
rt2500pci: Unknown symbol rt2x00mac_get_tx_stats
rt2500pci: Unknown symbol rt2x00pci_rxdone
rt2500pci: Unknown symbol rt2x00lib_beacondone
rt2500pci: Unknown symbol rt2x00mac_bss_info_changed
rt2500pci: Unknown symbol rt2x00pci_write_tx_data
cfg80211: exports duplicate symbol rfkill_force_state (owned by rfkill)
mac80211: Unknown symbol wiphy_register
mac80211: Unknown symbol wiphy_new
mac80211: Unknown symbol wiphy_unregister
mac80211: Unknown symbol ieee80211_radiotap_iterator_init
mac80211: Unknown symbol __ieee80211_get_channel
mac80211: Unknown symbol ieee80211_radiotap_iterator_next
mac80211: Unknown symbol ieee80211_channel_to_frequency
mac80211: Unknown symbol ieee80211_frequency_to_channel
mac80211: Unknown symbol wiphy_free
rt2x00lib: Unknown symbol ieee80211_register_hw
rt2x00lib: Unknown symbol ieee80211_get_hdrlen_from_skb
rt2x00lib: Unknown symbol ieee80211_wake_queue
rt2x00lib: Unknown symbol ieee80211_tx_status_irqsafe
rt2x00lib: Unknown symbol ieee80211_ctstoself_get
rt2x00lib: Unknown symbol ieee80211_wake_queues
rt2x00lib: Unknown symbol ieee80211_iterate_active_interfaces
rt2x00lib: Unknown symbol ieee80211_stop_queue
rt2x00lib: Unknown symbol ieee80211_stop_queues
rt2x00lib: Unknown symbol ieee80211_iterate_active_interfaces_atomic
rt2x00lib: Unknown symbol ieee80211_channel_to_frequency
rt2x00lib: Unknown symbol ieee80211_unregister_hw
rt2x00lib: Unknown symbol ieee80211_rts_get
rt2x00lib: Unknown symbol ieee80211_beacon_get
rt2x00lib: Unknown symbol ieee80211_rx_irqsafe
rt2x00pci: Unknown symbol rt2x00lib_suspend
rt2x00pci: Unknown symbol rt2x00lib_probe_dev
rt2x00pci: Unknown symbol ieee80211_free_hw
rt2x00pci: Unknown symbol ieee80211_alloc_hw
rt2x00pci: Unknown symbol rt2x00lib_rxdone
rt2x00pci: Unknown symbol rt2x00queue_get_entry
rt2x00pci: Unknown symbol rt2x00lib_remove_dev
rt2x00pci: Unknown symbol rt2x00lib_resume
rt61pci: Unknown symbol rt2x00mac_add_interface
rt61pci: Unknown symbol rt2x00mac_get_stats
rt61pci: Unknown symbol rt2x00pci_initialize
rt61pci: Unknown symbol rt2x00pci_uninitialize
rt61pci: Unknown symbol rt2x00queue_get_entry
rt61pci: Unknown symbol rt2x00pci_suspend
rt61pci: Unknown symbol rt2x00mac_config_interface
rt61pci: Unknown symbol rt2x00pci_remove
rt61pci: Unknown symbol rt2x00mac_remove_interface
rt61pci: Unknown symbol rt2x00lib_txdone
rt61pci: Unknown symbol rt2x00mac_config
rt61pci: Unknown symbol rt2x00queue_get_queue
rt61pci: Unknown symbol rt2x00mac_conf_tx
rt61pci: Unknown symbol rt2x00mac_start
rt61pci: Unknown symbol rt2x00mac_stop
rt61pci: Unknown symbol rt2x00mac_configure_filter
rt61pci: Unknown symbol rt2x00mac_tx
rt61pci: Unknown symbol rt2x00pci_resume
rt61pci: Unknown symbol rt2x00pci_probe
rt61pci: Unknown symbol rt2x00mac_get_tx_stats
rt61pci: Unknown symbol rt2x00pci_rxdone
rt61pci: Unknown symbol rt2x00mac_bss_info_changed
rt61pci: Unknown symbol rt2x00pci_write_tx_data
cfg80211: exports duplicate symbol rfkill_force_state (owned by rfkill)
mac80211: Unknown symbol wiphy_register
mac80211: Unknown symbol wiphy_new
mac80211: Unknown symbol wiphy_unregister
mac80211: Unknown symbol ieee80211_radiotap_iterator_init
mac80211: Unknown symbol __ieee80211_get_channel
mac80211: Unknown symbol ieee80211_radiotap_iterator_next
mac80211: Unknown symbol ieee80211_channel_to_frequency
mac80211: Unknown symbol ieee80211_frequency_to_channel
mac80211: Unknown symbol wiphy_free
rt2x00lib: Unknown symbol ieee80211_register_hw
rt2x00lib: Unknown symbol ieee80211_get_hdrlen_from_skb
rt2x00lib: Unknown symbol ieee80211_wake_queue
rt2x00lib: Unknown symbol ieee80211_tx_status_irqsafe
rt2x00lib: Unknown symbol ieee80211_ctstoself_get
rt2x00lib: Unknown symbol ieee80211_wake_queues
rt2x00lib: Unknown symbol ieee80211_iterate_active_interfaces
rt2x00lib: Unknown symbol ieee80211_stop_queue
rt2x00lib: Unknown symbol ieee80211_stop_queues
rt2x00lib: Unknown symbol ieee80211_iterate_active_interfaces_atomic
rt2x00lib: Unknown symbol ieee80211_channel_to_frequency
rt2x00lib: Unknown symbol ieee80211_unregister_hw
rt2x00lib: Unknown symbol ieee80211_rts_get
rt2x00lib: Unknown symbol ieee80211_beacon_get
rt2x00lib: Unknown symbol ieee80211_rx_irqsafe
rt2x00usb: Unknown symbol rt2x00lib_suspend
rt2x00usb: Unknown symbol rt2x00lib_probe_dev
rt2x00usb: Unknown symbol ieee80211_free_hw
rt2x00usb: Unknown symbol ieee80211_alloc_hw
rt2x00usb: Unknown symbol rt2x00lib_rxdone
rt2x00usb: Unknown symbol rt2x00lib_remove_dev
rt2x00usb: Unknown symbol rt2x00lib_txdone
rt2x00usb: Unknown symbol rt2x00queue_get_queue
rt2x00usb: Unknown symbol rt2x00lib_resume
rt2500usb: Unknown symbol rt2x00mac_add_interface
rt2500usb: Unknown symbol rt2x00mac_get_stats
rt2500usb: Unknown symbol rt2x00usb_init_rxentry
rt2500usb: Unknown symbol rt2x00usb_disable_radio
rt2500usb: Unknown symbol rt2x00usb_init_txentry
rt2500usb: Unknown symbol rt2x00usb_vendor_request_buff
rt2500usb: Unknown symbol rt2x00usb_kick_tx_queue
rt2500usb: Unknown symbol rt2x00usb_write_tx_data
rt2500usb: Unknown symbol rt2x00mac_config_interface
rt2500usb: Unknown symbol rt2x00mac_remove_interface
rt2500usb: Unknown symbol rt2x00usb_vendor_request
rt2500usb: Unknown symbol rt2x00usb_probe
rt2500usb: Unknown symbol rt2x00mac_config
rt2500usb: Unknown symbol rt2x00usb_suspend
rt2500usb: Unknown symbol rt2x00mac_conf_tx
rt2500usb: Unknown symbol rt2x00mac_start
rt2500usb: Unknown symbol rt2x00mac_stop
rt2500usb: Unknown symbol rt2x00mac_configure_filter
rt2500usb: Unknown symbol rt2x00usb_disconnect
rt2500usb: Unknown symbol rt2x00mac_tx
rt2500usb: Unknown symbol rt2x00usb_vendor_req_buff_lock
rt2500usb: Unknown symbol rt2x00mac_get_tx_stats
rt2500usb: Unknown symbol rt2x00usb_resume
rt2500usb: Unknown symbol rt2x00usb_uninitialize
rt2500usb: Unknown symbol rt2x00usb_initialize
rt2500usb: Unknown symbol rt2x00mac_bss_info_changed
cfg80211: exports duplicate symbol rfkill_force_state (owned by rfkill)
mac80211: Unknown symbol wiphy_register
mac80211: Unknown symbol wiphy_new
mac80211: Unknown symbol wiphy_unregister
mac80211: Unknown symbol ieee80211_radiotap_iterator_init
mac80211: Unknown symbol __ieee80211_get_channel
mac80211: Unknown symbol ieee80211_radiotap_iterator_next
mac80211: Unknown symbol ieee80211_channel_to_frequency
mac80211: Unknown symbol ieee80211_frequency_to_channel
mac80211: Unknown symbol wiphy_free
rt2x00lib: Unknown symbol ieee80211_register_hw
rt2x00lib: Unknown symbol ieee80211_get_hdrlen_from_skb
rt2x00lib: Unknown symbol ieee80211_wake_queue
rt2x00lib: Unknown symbol ieee80211_tx_status_irqsafe
rt2x00lib: Unknown symbol ieee80211_ctstoself_get
rt2x00lib: Unknown symbol ieee80211_wake_queues
rt2x00lib: Unknown symbol ieee80211_iterate_active_interfaces
rt2x00lib: Unknown symbol ieee80211_stop_queue
rt2x00lib: Unknown symbol ieee80211_stop_queues
rt2x00lib: Unknown symbol ieee80211_iterate_active_interfaces_atomic
rt2x00lib: Unknown symbol ieee80211_channel_to_frequency
rt2x00lib: Unknown symbol ieee80211_unregister_hw
rt2x00lib: Unknown symbol ieee80211_rts_get
rt2x00lib: Unknown symbol ieee80211_beacon_get
rt2x00lib: Unknown symbol ieee80211_rx_irqsafe
rt2x00usb: Unknown symbol rt2x00lib_suspend
rt2x00usb: Unknown symbol rt2x00lib_probe_dev
rt2x00usb: Unknown symbol ieee80211_free_hw
rt2x00usb: Unknown symbol ieee80211_alloc_hw
rt2x00usb: Unknown symbol rt2x00lib_rxdone
rt2x00usb: Unknown symbol rt2x00lib_remove_dev
rt2x00usb: Unknown symbol rt2x00lib_txdone
rt2x00usb: Unknown symbol rt2x00queue_get_queue
rt2x00usb: Unknown symbol rt2x00lib_resume
rt73usb: Unknown symbol rt2x00mac_add_interface
rt73usb: Unknown symbol rt2x00mac_get_stats
rt73usb: Unknown symbol rt2x00usb_init_rxentry
rt73usb: Unknown symbol rt2x00usb_disable_radio
rt73usb: Unknown symbol rt2x00usb_init_txentry
rt73usb: Unknown symbol rt2x00usb_vendor_request_buff
rt73usb: Unknown symbol rt2x00usb_kick_tx_queue
rt73usb: Unknown symbol rt2x00usb_write_tx_data
rt73usb: Unknown symbol rt2x00mac_config_interface
rt73usb: Unknown symbol rt2x00mac_remove_interface
rt73usb: Unknown symbol rt2x00usb_vendor_request
rt73usb: Unknown symbol rt2x00usb_probe
rt73usb: Unknown symbol rt2x00mac_config
rt73usb: Unknown symbol rt2x00usb_suspend
rt73usb: Unknown symbol rt2x00mac_conf_tx
rt73usb: Unknown symbol rt2x00mac_start
rt73usb: Unknown symbol rt2x00mac_stop
rt73usb: Unknown symbol rt2x00mac_configure_filter
rt73usb: Unknown symbol rt2x00usb_disconnect
rt73usb: Unknown symbol rt2x00mac_tx
rt73usb: Unknown symbol rt2x00usb_vendor_req_buff_lock
rt73usb: Unknown symbol rt2x00mac_get_tx_stats
rt73usb: Unknown symbol rt2x00usb_resume
rt73usb: Unknown symbol rt2x00usb_uninitialize
rt73usb: Unknown symbol rt2x00usb_initialize
rt73usb: Unknown symbol rt2x00mac_bss_info_changed
usbcore: registered new interface driver cdc_ether
usbcore: registered new interface driver rndis_host
usbcore: registered new interface driver rndis_wlan
cfg80211: exports duplicate symbol rfkill_force_state (owned by rfkill)
mac80211: Unknown symbol wiphy_register
mac80211: Unknown symbol wiphy_new
mac80211: Unknown symbol wiphy_unregister
mac80211: Unknown symbol ieee80211_radiotap_iterator_init
mac80211: Unknown symbol __ieee80211_get_channel
mac80211: Unknown symbol ieee80211_radiotap_iterator_next
mac80211: Unknown symbol ieee80211_channel_to_frequency
mac80211: Unknown symbol ieee80211_frequency_to_channel
mac80211: Unknown symbol wiphy_free
at76_usb: Unknown symbol ieee80211_free_hw
at76_usb: Unknown symbol ieee80211_alloc_hw
at76_usb: Unknown symbol ieee80211_register_hw
at76_usb: Unknown symbol ieee80211_tx_status_irqsafe
at76_usb: Unknown symbol ieee80211_wake_queues
at76_usb: Unknown symbol ieee80211_stop_queues
at76_usb: Unknown symbol ieee80211_scan_completed
at76_usb: Unknown symbol ieee80211_unregister_hw
at76_usb: Unknown symbol ieee80211_rx_irqsafe
cfg80211: exports duplicate symbol rfkill_force_state (owned by rfkill)
mac80211: Unknown symbol wiphy_register
mac80211: Unknown symbol wiphy_new
mac80211: Unknown symbol wiphy_unregister
mac80211: Unknown symbol ieee80211_radiotap_iterator_init
mac80211: Unknown symbol __ieee80211_get_channel
mac80211: Unknown symbol ieee80211_radiotap_iterator_next
mac80211: Unknown symbol ieee80211_channel_to_frequency
mac80211: Unknown symbol ieee80211_frequency_to_channel
mac80211: Unknown symbol wiphy_free
ath5k: Unknown symbol ieee80211_free_hw
ath5k: Unknown symbol ieee80211_alloc_hw
ath5k: Unknown symbol ieee80211_register_hw
ath5k: Unknown symbol ieee80211_get_hdrlen_from_skb
ath5k: Unknown symbol ieee80211_generic_frame_duration
ath5k: Unknown symbol __ieee80211_get_tx_led_name
ath5k: Unknown symbol __ieee80211_get_rx_led_name
ath5k: Unknown symbol ieee80211_wake_queues
ath5k: Unknown symbol __ieee80211_rx
ath5k: Unknown symbol ieee80211_tx_status
ath5k: Unknown symbol ieee80211_stop_queue
ath5k: Unknown symbol ieee80211_stop_queues
ath5k: Unknown symbol ieee80211_unregister_hw
ath5k: Unknown symbol ieee80211_beacon_get
ath5k: Unknown symbol ieee80211_frequency_to_channel
cfg80211: exports duplicate symbol rfkill_force_state (owned by rfkill)
mac80211: Unknown symbol wiphy_register
mac80211: Unknown symbol wiphy_new
mac80211: Unknown symbol wiphy_unregister
mac80211: Unknown symbol ieee80211_radiotap_iterator_init
mac80211: Unknown symbol __ieee80211_get_channel
mac80211: Unknown symbol ieee80211_radiotap_iterator_next
mac80211: Unknown symbol ieee80211_channel_to_frequency
mac80211: Unknown symbol ieee80211_frequency_to_channel
mac80211: Unknown symbol wiphy_free
ACPI: PCI Interrupt 0000:03:00.0[A] -> Link [LK4E] -> GSI 19 (level,
high) -> IRQ 19
PCI: Setting latency timer of device 0000:03:00.0 to 64
ssb: Sonics Silicon Backplane found on PCI device 0000:03:00.0
b43: Unknown symbol ieee80211_free_hw
b43: Unknown symbol ieee80211_alloc_hw
b43: Unknown symbol ieee80211_register_hw
b43: Unknown symbol ieee80211_generic_frame_duration
b43: Unknown symbol ieee80211_wake_queue
b43: Unknown symbol __ieee80211_get_tx_led_name
b43: Unknown symbol ieee80211_tx_status_irqsafe
b43: Unknown symbol __ieee80211_get_rx_led_name
b43: Unknown symbol ieee80211_ctstoself_get
b43: Unknown symbol ieee80211_stop_queue
b43: Unknown symbol __ieee80211_get_assoc_led_name
b43: Unknown symbol ieee80211_unregister_hw
b43: Unknown symbol ieee80211_hdrlen
b43: Unknown symbol ieee80211_rts_get
b43: Unknown symbol ieee80211_beacon_get
b43: Unknown symbol ieee80211_rx_irqsafe
cfg80211: exports duplicate symbol rfkill_force_state (owned by rfkill)
mac80211: Unknown symbol wiphy_register
mac80211: Unknown symbol wiphy_new
mac80211: Unknown symbol wiphy_unregister
mac80211: Unknown symbol ieee80211_radiotap_iterator_init
mac80211: Unknown symbol __ieee80211_get_channel
mac80211: Unknown symbol ieee80211_radiotap_iterator_next
mac80211: Unknown symbol ieee80211_channel_to_frequency
mac80211: Unknown symbol ieee80211_frequency_to_channel
mac80211: Unknown symbol wiphy_free
b43legacy: Unknown symbol ieee80211_free_hw
b43legacy: Unknown symbol ieee80211_alloc_hw
b43legacy: Unknown symbol ieee80211_register_hw
b43legacy: Unknown symbol ieee80211_generic_frame_duration
b43legacy: Unknown symbol ieee80211_wake_queue
b43legacy: Unknown symbol __ieee80211_get_tx_led_name
b43legacy: Unknown symbol ieee80211_tx_status_irqsafe
b43legacy: Unknown symbol __ieee80211_get_rx_led_name
b43legacy: Unknown symbol ieee80211_ctstoself_get
b43legacy: Unknown symbol ieee80211_stop_queue
b43legacy: Unknown symbol ieee80211_stop_queues
b43legacy: Unknown symbol ieee80211_get_hdrlen
b43legacy: Unknown symbol __ieee80211_get_assoc_led_name
b43legacy: Unknown symbol ieee80211_unregister_hw
b43legacy: Unknown symbol ieee80211_hdrlen
b43legacy: Unknown symbol ieee80211_rts_get
b43legacy: Unknown symbol ieee80211_beacon_get
b43legacy: Unknown symbol ieee80211_rx_irqsafe
cfg80211: exports duplicate symbol rfkill_force_state (owned by rfkill)
mac80211: Unknown symbol wiphy_register
mac80211: Unknown symbol wiphy_new
mac80211: Unknown symbol wiphy_unregister
mac80211: Unknown symbol ieee80211_radiotap_iterator_init
mac80211: Unknown symbol __ieee80211_get_channel
mac80211: Unknown symbol ieee80211_radiotap_iterator_next
mac80211: Unknown symbol ieee80211_channel_to_frequency
mac80211: Unknown symbol ieee80211_frequency_to_channel
mac80211: Unknown symbol wiphy_free
b43: Unknown symbol ieee80211_free_hw
b43: Unknown symbol ieee80211_alloc_hw
b43: Unknown symbol ieee80211_register_hw
b43: Unknown symbol ieee80211_generic_frame_duration
b43: Unknown symbol ieee80211_wake_queue
b43: Unknown symbol __ieee80211_get_tx_led_name
b43: Unknown symbol ieee80211_tx_status_irqsafe
b43: Unknown symbol __ieee80211_get_rx_led_name
b43: Unknown symbol ieee80211_ctstoself_get
b43: Unknown symbol ieee80211_stop_queue
b43: Unknown symbol __ieee80211_get_assoc_led_name
b43: Unknown symbol ieee80211_unregister_hw
b43: Unknown symbol ieee80211_hdrlen
b43: Unknown symbol ieee80211_rts_get
b43: Unknown symbol ieee80211_beacon_get
b43: Unknown symbol ieee80211_rx_irqsafe

[root@localhost compat-wireless-2008-08-06]# modprobe -v b43
insmod /lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko 
WARNING: Error inserting cfg80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/wireless/cfg80211.ko):
Invalid module format
insmod /lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko 
WARNING: Error inserting mac80211
(/lib/modules/2.6.25.14-69.fc8/updates/net/mac80211/mac80211.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
insmod /lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/b43/b43.ko 
FATAL: Error inserting b43
(/lib/modules/2.6.25.14-69.fc8/updates/drivers/net/wireless/b43/b43.ko):
Unknown symbol in module, or unknown parameter (see dmesg)

