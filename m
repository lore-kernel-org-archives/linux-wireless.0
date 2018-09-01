Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36654 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725964AbeIALux (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Sep 2018 07:50:53 -0400
Date: Sat, 1 Sep 2018 15:37:31 +0800
From: kbuild test robot <lkp@intel.com>
To: Luca Coelho <luca@coelho.fi>
Cc: kbuild-all@01.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 19/28] mac80211: support reporting 0-length PSDU in
 radiotap
Message-ID: <201809011215.zgl8YnKb%fengguang.wu@intel.com> (sfid-20180901_093955_244997_2D3F1FB0)
References: <20180831083130.15525-20-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9amGYk9869ThD9tj"
In-Reply-To: <20180831083130.15525-20-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Shaul,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mac80211-next/master]
[also build test WARNING on next-20180831]
[cannot apply to v4.19-rc1]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Luca-Coelho/cfg80211-mac80211-patches-from-our-internal-tree-2018-08-31/20180901-062742
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   WARNING: convert(1) not found, for SVG to PDF conversion install ImageMagick (https://www.imagemagick.org)
   include/linux/srcu.h:175: warning: Function parameter or member 'p' not described in 'srcu_dereference_notrace'
   include/linux/srcu.h:175: warning: Function parameter or member 'sp' not described in 'srcu_dereference_notrace'
   include/linux/gfp.h:1: warning: no structured comments found
   include/net/cfg80211.h:4383: warning: Function parameter or member 'wext.ibss' not described in 'wireless_dev'
   include/net/cfg80211.h:4383: warning: Function parameter or member 'wext.connect' not described in 'wireless_dev'
   include/net/cfg80211.h:4383: warning: Function parameter or member 'wext.keys' not described in 'wireless_dev'
   include/net/cfg80211.h:4383: warning: Function parameter or member 'wext.ie' not described in 'wireless_dev'
   include/net/cfg80211.h:4383: warning: Function parameter or member 'wext.ie_len' not described in 'wireless_dev'
   include/net/cfg80211.h:4383: warning: Function parameter or member 'wext.bssid' not described in 'wireless_dev'
   include/net/cfg80211.h:4383: warning: Function parameter or member 'wext.ssid' not described in 'wireless_dev'
   include/net/cfg80211.h:4383: warning: Function parameter or member 'wext.default_key' not described in 'wireless_dev'
   include/net/cfg80211.h:4383: warning: Function parameter or member 'wext.default_mgmt_key' not described in 'wireless_dev'
   include/net/cfg80211.h:4383: warning: Function parameter or member 'wext.prev_bssid_valid' not described in 'wireless_dev'
   include/net/mac80211.h:2360: warning: Function parameter or member 'radiotap_timestamp.units_pos' not described in 'ieee80211_hw'
   include/net/mac80211.h:2360: warning: Function parameter or member 'radiotap_timestamp.accuracy' not described in 'ieee80211_hw'
>> include/net/mac80211.h:1180: warning: Enum value 'RX_FLAG_NO_PSDU' not described in enum 'mac80211_rx_flags'
>> include/net/mac80211.h:1180: warning: Excess enum value 'RX_FLAG_RADIOTAP_NO_PSDU' description in 'mac80211_rx_flags'
   include/net/mac80211.h:978: warning: Function parameter or member 'control.rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:978: warning: Function parameter or member 'control.rts_cts_rate_idx' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:978: warning: Function parameter or member 'control.use_rts' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:978: warning: Function parameter or member 'control.use_cts_prot' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:978: warning: Function parameter or member 'control.short_preamble' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:978: warning: Function parameter or member 'control.skip_table' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:978: warning: Function parameter or member 'control.jiffies' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:978: warning: Function parameter or member 'control.vif' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:978: warning: Function parameter or member 'control.hw_key' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:978: warning: Function parameter or member 'control.flags' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:978: warning: Function parameter or member 'control.enqueue_time' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:978: warning: Function parameter or member 'ack' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:978: warning: Function parameter or member 'ack.cookie' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:978: warning: Function parameter or member 'status.rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:978: warning: Function parameter or member 'status.ack_signal' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:978: warning: Function parameter or member 'status.ampdu_ack_len' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:978: warning: Function parameter or member 'status.ampdu_len' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:978: warning: Function parameter or member 'status.antenna' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:978: warning: Function parameter or member 'status.tx_time' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:978: warning: Function parameter or member 'status.is_valid_ack_signal' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:978: warning: Function parameter or member 'status.status_driver_data' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:978: warning: Function parameter or member 'driver_rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:978: warning: Function parameter or member 'pad' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:978: warning: Function parameter or member 'rate_driver_data' not described in 'ieee80211_tx_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'rx_stats_avg' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'rx_stats_avg.signal' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'rx_stats_avg.chain_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.filtered' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.retry_failed' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.retry_count' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.lost_packets' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.last_tdls_pkt_time' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.msdu_retries' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.msdu_failed' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.last_ack' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.last_ack_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.ack_signal_filled' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.avg_ack_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'tx_stats.packets' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'tx_stats.bytes' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'tx_stats.last_rate' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'tx_stats.msdu' not described in 'sta_info'
   include/linux/mod_devicetable.h:763: warning: Function parameter or member 'driver_data' not described in 'typec_device_id'
   kernel/sched/fair.c:3371: warning: Function parameter or member 'flags' not described in 'attach_entity_load_avg'
   arch/x86/include/asm/atomic.h:84: warning: Excess function parameter 'i' description in 'arch_atomic_sub_and_test'
   arch/x86/include/asm/atomic.h:84: warning: Excess function parameter 'v' description in 'arch_atomic_sub_and_test'
   arch/x86/include/asm/atomic.h:96: warning: Excess function parameter 'v' description in 'arch_atomic_inc'
   arch/x86/include/asm/atomic.h:109: warning: Excess function parameter 'v' description in 'arch_atomic_dec'
   arch/x86/include/asm/atomic.h:124: warning: Excess function parameter 'v' description in 'arch_atomic_dec_and_test'
   arch/x86/include/asm/atomic.h:138: warning: Excess function parameter 'v' description in 'arch_atomic_inc_and_test'
   arch/x86/include/asm/atomic.h:153: warning: Excess function parameter 'i' description in 'arch_atomic_add_negative'
   arch/x86/include/asm/atomic.h:153: warning: Excess function parameter 'v' description in 'arch_atomic_add_negative'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.active' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.active' not described in 'dma_buf'
   include/linux/dma-fence-array.h:54: warning: Function parameter or member 'work' not described in 'dma_fence_array'
   include/linux/gpio/driver.h:142: warning: Function parameter or member 'request_key' not described in 'gpio_irq_chip'
   include/linux/iio/hw-consumer.h:1: warning: no structured comments found
   include/linux/input/sparse-keymap.h:46: warning: Function parameter or member 'sw' not described in 'key_entry'
   drivers/pci/pci.c:218: warning: Excess function parameter 'p' description in 'pci_dev_str_match_path'
   include/linux/regulator/driver.h:227: warning: Function parameter or member 'resume' not described in 'regulator_ops'
   drivers/regulator/core.c:4479: warning: Excess function parameter 'state' description in 'regulator_suspend'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw0' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw1' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw2' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw3' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.eadm' not described in 'irb'
   drivers/slimbus/stream.c:1: warning: no structured comments found
   drivers/target/target_core_device.c:1: warning: no structured comments found
   drivers/usb/dwc3/gadget.c:510: warning: Excess function parameter 'dwc' description in 'dwc3_gadget_start_config'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/bus.c:1: warning: no structured comments found
   drivers/usb/typec/bus.c:268: warning: Function parameter or member 'mode' not described in 'typec_match_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/class.c:1: warning: no structured comments found
   include/linux/w1.h:281: warning: Function parameter or member 'of_match_table' not described in 'w1_family'
   fs/direct-io.c:257: warning: Excess function parameter 'offset' description in 'dio_complete'
   fs/file_table.c:1: warning: no structured comments found
   fs/libfs.c:477: warning: Excess function parameter 'available' description in 'simple_write_end'
   fs/posix_acl.c:646: warning: Function parameter or member 'inode' not described in 'posix_acl_update_mode'
   fs/posix_acl.c:646: warning: Function parameter or member 'mode_p' not described in 'posix_acl_update_mode'
   fs/posix_acl.c:646: warning: Function parameter or member 'acl' not described in 'posix_acl_update_mode'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:183: warning: Function parameter or member 'blockable' not described in 'amdgpu_mn_read_lock'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:254: warning: Function parameter or member 'blockable' not described in 'amdgpu_mn_invalidate_range_start_gfx'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:302: warning: Function parameter or member 'blockable' not described in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:2986: warning: Excess function parameter 'dev' description in 'amdgpu_vm_get_task_info'

vim +1180 include/net/mac80211.h

e6a9854b0 Johannes Berg       2008-10-21  1057  
7ac1bd6ae Johannes Berg       2007-09-14  1058  
7ac1bd6ae Johannes Berg       2007-09-14  1059  /**
7ac1bd6ae Johannes Berg       2007-09-14  1060   * enum mac80211_rx_flags - receive flags
7ac1bd6ae Johannes Berg       2007-09-14  1061   *
7ac1bd6ae Johannes Berg       2007-09-14  1062   * These flags are used with the @flag member of &struct ieee80211_rx_status.
7ac1bd6ae Johannes Berg       2007-09-14  1063   * @RX_FLAG_MMIC_ERROR: Michael MIC error was reported on this frame.
7ac1bd6ae Johannes Berg       2007-09-14  1064   *	Use together with %RX_FLAG_MMIC_STRIPPED.
7ac1bd6ae Johannes Berg       2007-09-14  1065   * @RX_FLAG_DECRYPTED: This frame was decrypted in hardware.
7ac1bd6ae Johannes Berg       2007-09-14  1066   * @RX_FLAG_MMIC_STRIPPED: the Michael MIC is stripped off this frame,
7ac1bd6ae Johannes Berg       2007-09-14  1067   *	verification has been done by the hardware.
cef0acd4d David Spinadel      2016-11-21  1068   * @RX_FLAG_IV_STRIPPED: The IV and ICV are stripped from this frame.
7ac1bd6ae Johannes Berg       2007-09-14  1069   *	If this flag is set, the stack cannot do any replay detection
7ac1bd6ae Johannes Berg       2007-09-14  1070   *	hence the driver or hardware will have to do that.
981d94a80 Johannes Berg       2015-06-12  1071   * @RX_FLAG_PN_VALIDATED: Currently only valid for CCMP/GCMP frames, this
981d94a80 Johannes Berg       2015-06-12  1072   *	flag indicates that the PN was verified for replay protection.
981d94a80 Johannes Berg       2015-06-12  1073   *	Note that this flag is also currently only supported when a frame
981d94a80 Johannes Berg       2015-06-12  1074   *	is also decrypted (ie. @RX_FLAG_DECRYPTED must be set)
84ea3a18c Luis de Bethencourt 2016-03-18  1075   * @RX_FLAG_DUP_VALIDATED: The driver should set this flag if it did
84ea3a18c Luis de Bethencourt 2016-03-18  1076   *	de-duplication by itself.
72abd81b9 Johannes Berg       2007-09-17  1077   * @RX_FLAG_FAILED_FCS_CRC: Set this flag if the FCS check failed on
72abd81b9 Johannes Berg       2007-09-17  1078   *	the frame.
72abd81b9 Johannes Berg       2007-09-17  1079   * @RX_FLAG_FAILED_PLCP_CRC: Set this flag if the PCLP check failed on
72abd81b9 Johannes Berg       2007-09-17  1080   *	the frame.
f4bda337b Thomas Pedersen     2012-11-13  1081   * @RX_FLAG_MACTIME_START: The timestamp passed in the RX status (@mactime
6ebacbb79 Johannes Berg       2011-02-23  1082   *	field) is valid and contains the time the first symbol of the MPDU
6ebacbb79 Johannes Berg       2011-02-23  1083   *	was received. This is useful in monitor mode and for proper IBSS
6ebacbb79 Johannes Berg       2011-02-23  1084   *	merging.
f4bda337b Thomas Pedersen     2012-11-13  1085   * @RX_FLAG_MACTIME_END: The timestamp passed in the RX status (@mactime
f4bda337b Thomas Pedersen     2012-11-13  1086   *	field) is valid and contains the time the last symbol of the MPDU
f4bda337b Thomas Pedersen     2012-11-13  1087   *	(including FCS) was received.
f4a0f0c52 Johannes Berg       2016-01-25  1088   * @RX_FLAG_MACTIME_PLCP_START: The timestamp passed in the RX status (@mactime
f4a0f0c52 Johannes Berg       2016-01-25  1089   *	field) is valid and contains the time the SYNC preamble was received.
fe8431f89 Felix Fietkau       2012-03-01  1090   * @RX_FLAG_NO_SIGNAL_VAL: The signal strength value is not present.
fe8431f89 Felix Fietkau       2012-03-01  1091   *	Valid only for data frames (mainly A-MPDU)
4c2986779 Johannes Berg       2012-07-05  1092   * @RX_FLAG_AMPDU_DETAILS: A-MPDU details are known, in particular the reference
4c2986779 Johannes Berg       2012-07-05  1093   *	number (@ampdu_reference) must be populated and be a distinct number for
4c2986779 Johannes Berg       2012-07-05  1094   *	each A-MPDU
4c2986779 Johannes Berg       2012-07-05  1095   * @RX_FLAG_AMPDU_LAST_KNOWN: last subframe is known, should be set on all
4c2986779 Johannes Berg       2012-07-05  1096   *	subframes of a single A-MPDU
4c2986779 Johannes Berg       2012-07-05  1097   * @RX_FLAG_AMPDU_IS_LAST: this subframe is the last subframe of the A-MPDU
4c2986779 Johannes Berg       2012-07-05  1098   * @RX_FLAG_AMPDU_DELIM_CRC_ERROR: A delimiter CRC error has been detected
4c2986779 Johannes Berg       2012-07-05  1099   *	on this subframe
4c2986779 Johannes Berg       2012-07-05  1100   * @RX_FLAG_AMPDU_DELIM_CRC_KNOWN: The delimiter CRC field is known (the CRC
4c2986779 Johannes Berg       2012-07-05  1101   *	is stored in the @ampdu_delimiter_crc field)
f980ebc05 Sara Sharon         2016-02-24  1102   * @RX_FLAG_MIC_STRIPPED: The mic was stripped of this packet. Decryption was
f980ebc05 Sara Sharon         2016-02-24  1103   *	done by the hardware
178830481 Grzegorz Bajorski   2015-12-11  1104   * @RX_FLAG_ONLY_MONITOR: Report frame only to monitor interfaces without
178830481 Grzegorz Bajorski   2015-12-11  1105   *	processing it in any regular way.
178830481 Grzegorz Bajorski   2015-12-11  1106   *	This is useful if drivers offload some frames but still want to report
178830481 Grzegorz Bajorski   2015-12-11  1107   *	them for sniffing purposes.
178830481 Grzegorz Bajorski   2015-12-11  1108   * @RX_FLAG_SKIP_MONITOR: Process and report frame to all interfaces except
178830481 Grzegorz Bajorski   2015-12-11  1109   *	monitor interfaces.
178830481 Grzegorz Bajorski   2015-12-11  1110   *	This is useful if drivers offload some frames but still want to report
178830481 Grzegorz Bajorski   2015-12-11  1111   *	them for sniffing purposes.
0cfcefef1 Michal Kazior       2013-09-23  1112   * @RX_FLAG_AMSDU_MORE: Some drivers may prefer to report separate A-MSDU
0cfcefef1 Michal Kazior       2013-09-23  1113   *	subframes instead of a one huge frame for performance reasons.
0cfcefef1 Michal Kazior       2013-09-23  1114   *	All, but the last MSDU from an A-MSDU should have this flag set. E.g.
0cfcefef1 Michal Kazior       2013-09-23  1115   *	if an A-MSDU has 3 frames, the first 2 must have the flag set, while
0cfcefef1 Michal Kazior       2013-09-23  1116   *	the 3rd (last) one must not have this flag set. The flag is used to
0cfcefef1 Michal Kazior       2013-09-23  1117   *	deal with retransmission/duplication recovery properly since A-MSDU
0cfcefef1 Michal Kazior       2013-09-23  1118   *	subframes share the same sequence number. Reported subframes can be
0cfcefef1 Michal Kazior       2013-09-23  1119   *	either regular MSDU or singly A-MSDUs. Subframes must not be
0cfcefef1 Michal Kazior       2013-09-23  1120   *	interleaved with other frames.
1f7bba79a Johannes Berg       2014-11-06  1121   * @RX_FLAG_RADIOTAP_VENDOR_DATA: This frame contains vendor-specific
1f7bba79a Johannes Berg       2014-11-06  1122   *	radiotap data in the skb->data (before the frame) as described by
1f7bba79a Johannes Berg       2014-11-06  1123   *	the &struct ieee80211_vendor_radiotap.
f631a77ba Sara Sharon         2016-05-03  1124   * @RX_FLAG_ALLOW_SAME_PN: Allow the same PN as same packet before.
f631a77ba Sara Sharon         2016-05-03  1125   *	This is used for AMSDU subframes which can have the same PN as
f631a77ba Sara Sharon         2016-05-03  1126   *	the first subframe.
cef0acd4d David Spinadel      2016-11-21  1127   * @RX_FLAG_ICV_STRIPPED: The ICV is stripped from this frame. CRC checking must
cef0acd4d David Spinadel      2016-11-21  1128   *	be done in the hardware.
7299d6f7b Johannes Berg       2018-02-19  1129   * @RX_FLAG_AMPDU_EOF_BIT: Value of the EOF bit in the A-MPDU delimiter for this
7299d6f7b Johannes Berg       2018-02-19  1130   *	frame
7299d6f7b Johannes Berg       2018-02-19  1131   * @RX_FLAG_AMPDU_EOF_BIT_KNOWN: The EOF value is known
41cbb0f5a Luca Coelho         2018-06-09  1132   * @RX_FLAG_RADIOTAP_HE: HE radiotap data is present
41cbb0f5a Luca Coelho         2018-06-09  1133   *	(&struct ieee80211_radiotap_he, mac80211 will fill in
41cbb0f5a Luca Coelho         2018-06-09  1134   *	 - DATA3_DATA_MCS
41cbb0f5a Luca Coelho         2018-06-09  1135   *	 - DATA3_DATA_DCM
41cbb0f5a Luca Coelho         2018-06-09  1136   *	 - DATA3_CODING
41cbb0f5a Luca Coelho         2018-06-09  1137   *	 - DATA5_GI
41cbb0f5a Luca Coelho         2018-06-09  1138   *	 - DATA5_DATA_BW_RU_ALLOC
41cbb0f5a Luca Coelho         2018-06-09  1139   *	 - DATA6_NSTS
41cbb0f5a Luca Coelho         2018-06-09  1140   *	 - DATA3_STBC
41cbb0f5a Luca Coelho         2018-06-09  1141   *	from the RX info data, so leave those zeroed when building this data)
41cbb0f5a Luca Coelho         2018-06-09  1142   * @RX_FLAG_RADIOTAP_HE_MU: HE MU radiotap data is present
41cbb0f5a Luca Coelho         2018-06-09  1143   *	(&struct ieee80211_radiotap_he_mu)
bcaceebb4 Shaul Triebitz      2018-08-31  1144   * @RX_FLAG_RADIOTAP_LSIG: L-SIG radiotap data is present
4740b2632 Shaul Triebitz      2018-08-31  1145   * @RX_FLAG_RADIOTAP_NO_PSDU: indicate that the radiotap "0-length PSDU" field
4740b2632 Shaul Triebitz      2018-08-31  1146   *	should be added, the value for it is in &struct ieee80211_rx_status.
4740b2632 Shaul Triebitz      2018-08-31  1147   *	Note that if this value isn't known the frame shouldn't be reported.
7ac1bd6ae Johannes Berg       2007-09-14  1148   */
7ac1bd6ae Johannes Berg       2007-09-14  1149  enum mac80211_rx_flags {
4c2986779 Johannes Berg       2012-07-05  1150  	RX_FLAG_MMIC_ERROR		= BIT(0),
4c2986779 Johannes Berg       2012-07-05  1151  	RX_FLAG_DECRYPTED		= BIT(1),
f4a0f0c52 Johannes Berg       2016-01-25  1152  	RX_FLAG_MACTIME_PLCP_START	= BIT(2),
4c2986779 Johannes Berg       2012-07-05  1153  	RX_FLAG_MMIC_STRIPPED		= BIT(3),
4c2986779 Johannes Berg       2012-07-05  1154  	RX_FLAG_IV_STRIPPED		= BIT(4),
4c2986779 Johannes Berg       2012-07-05  1155  	RX_FLAG_FAILED_FCS_CRC		= BIT(5),
4c2986779 Johannes Berg       2012-07-05  1156  	RX_FLAG_FAILED_PLCP_CRC 	= BIT(6),
f4bda337b Thomas Pedersen     2012-11-13  1157  	RX_FLAG_MACTIME_START		= BIT(7),
7fdd69c5a Johannes Berg       2017-04-26  1158  	RX_FLAG_NO_SIGNAL_VAL		= BIT(8),
7fdd69c5a Johannes Berg       2017-04-26  1159  	RX_FLAG_AMPDU_DETAILS		= BIT(9),
7fdd69c5a Johannes Berg       2017-04-26  1160  	RX_FLAG_PN_VALIDATED		= BIT(10),
7fdd69c5a Johannes Berg       2017-04-26  1161  	RX_FLAG_DUP_VALIDATED		= BIT(11),
7fdd69c5a Johannes Berg       2017-04-26  1162  	RX_FLAG_AMPDU_LAST_KNOWN	= BIT(12),
7fdd69c5a Johannes Berg       2017-04-26  1163  	RX_FLAG_AMPDU_IS_LAST		= BIT(13),
7fdd69c5a Johannes Berg       2017-04-26  1164  	RX_FLAG_AMPDU_DELIM_CRC_ERROR	= BIT(14),
7fdd69c5a Johannes Berg       2017-04-26  1165  	RX_FLAG_AMPDU_DELIM_CRC_KNOWN	= BIT(15),
7fdd69c5a Johannes Berg       2017-04-26  1166  	RX_FLAG_MACTIME_END		= BIT(16),
7fdd69c5a Johannes Berg       2017-04-26  1167  	RX_FLAG_ONLY_MONITOR		= BIT(17),
7fdd69c5a Johannes Berg       2017-04-26  1168  	RX_FLAG_SKIP_MONITOR		= BIT(18),
7fdd69c5a Johannes Berg       2017-04-26  1169  	RX_FLAG_AMSDU_MORE		= BIT(19),
7fdd69c5a Johannes Berg       2017-04-26  1170  	RX_FLAG_RADIOTAP_VENDOR_DATA	= BIT(20),
7fdd69c5a Johannes Berg       2017-04-26  1171  	RX_FLAG_MIC_STRIPPED		= BIT(21),
7fdd69c5a Johannes Berg       2017-04-26  1172  	RX_FLAG_ALLOW_SAME_PN		= BIT(22),
7fdd69c5a Johannes Berg       2017-04-26  1173  	RX_FLAG_ICV_STRIPPED		= BIT(23),
7299d6f7b Johannes Berg       2018-02-19  1174  	RX_FLAG_AMPDU_EOF_BIT		= BIT(24),
7299d6f7b Johannes Berg       2018-02-19  1175  	RX_FLAG_AMPDU_EOF_BIT_KNOWN	= BIT(25),
41cbb0f5a Luca Coelho         2018-06-09  1176  	RX_FLAG_RADIOTAP_HE		= BIT(26),
41cbb0f5a Luca Coelho         2018-06-09  1177  	RX_FLAG_RADIOTAP_HE_MU		= BIT(27),
bcaceebb4 Shaul Triebitz      2018-08-31  1178  	RX_FLAG_RADIOTAP_LSIG		= BIT(28),
4740b2632 Shaul Triebitz      2018-08-31  1179  	RX_FLAG_NO_PSDU			= BIT(29),
7ac1bd6ae Johannes Berg       2007-09-14 @1180  };
7ac1bd6ae Johannes Berg       2007-09-14  1181  

:::::: The code at line 1180 was first introduced by commit
:::::: 7ac1bd6aecc92cfe6ec11891819dd4c26f2f7879 [MAC80211]: some more documentation

:::::: TO: Johannes Berg <johannes@sipsolutions.net>
:::::: CC: David S. Miller <davem@sunset.davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--9amGYk9869ThD9tj
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICND5iVsAAy5jb25maWcAjFxZc9u4ln7vX8FKV00ldSuJt7jdM+UHCAQltLiFALX4haXI
dKK6tuTR0p38+zkHIMXtwHe6ujsxDgBiOct3Fvj333732Om4e1kdN+vV8/Mv73u5LferY/no
PW2ey//x/MSLE+0JX+pP0DncbE8/P2+u7269m0+Xf366+LhfX3rTcr8tnz2+2z5tvp9g+Ga3
/e333+Df36Hx5RVm2v+39329/viH994vv21WW++PT9cw+vL2g/0b9OVJHMhxwXkhVTHm/P5X
3QQ/FDORKZnE939cXF9cnPuGLB6fSedmmX0t5kk2bWYY5TL0tYxEIRaajUJRqCTTDV1PMsH8
QsZBAv8rNFM42GxgbE7k2TuUx9Nrs8xRlkxFXCRxoaK0mUjGUhcinhUsGxehjKS+v77CY6gW
nESphK9robS3OXjb3REnrkeHCWdhvZ1375pxbULBcp0Qg80eC8VCjUOrxgmbiWIqsliExfhB
tlbapoyAckWTwoeI0ZTFg2tE4iLcNITums4bbS+ovcd+B1zWW/TFw9ujk7fJN8T5+iJgeaiL
SaJ0zCJx/+79drctP7SuSS3VTKacnJtniVJFJKIkWxZMa8YnZL9ciVCOiO+bo2QZnwADgDjC
t4AnwppNgee9w+nb4dfhWL40bDoWscgkNyKRZslItKSqRVKTZE5TMqFENmMaGS9K/NZ4pAZJ
xoVfiY+Mxw1VpSxTAjs1bRzYeKqSHMYUc6b5xE9aI8zW2l18phk9eMZCCVRRhEzpgi95SOzL
iPusOaYe2cwnZiLW6k1iEYFCYP5fudJEvyhRRZ7iWuqL0JuXcn+g7mLyUKQwKvElb7N8nCBF
+qEg+cGQScpEjid4P2anmSJYJs2EiFINc8Si/cm6fZaEeaxZtiTnr3q1aValp/lnvTr82zvC
Vr3V9tE7HFfHg7dar3en7XGz/d7sWUs+LWBAwThP4FuWR86fQB4y99SQB5/LeO6p4WlC32UB
tPZ08CMoeDhkSrkq27k9XPXGy6n9i0v68lhV1oNPgO0Nl/QYeM5iXYyQuaFDHkcsLXQ4KoIw
V5P2p/g4S/JU0apiIvg0TSTMBNerk4zmDLsItAZmLrJPJkJG3+4onIJKmxmLlfnEjsHoJilc
jnwQKOfIu/BHxGLe4aV+NwV/IWZjwIPwLdAgqmcdculf3rYUBwisDuEauUiN1tEZ46I3JuUq
ncKSQqZxTQ3V3n57fRHobAlKNaPPcCx0BNa+qPQE3WmpAvVmj2DCYpcAp4mSC0JGW3IGNz2l
Lykf00O6+6fHMtC/Qe5aca7FgqSINHGdgxzHLAx8kmg26KAZTeqgqQnYRJLCJG2lmT+TsLXq
PugzhTlHLMuk49qnOHAZ0WNHafDmZSMzGSgQUGJjtMCEqdYSYLYYbAXIcUdZKfGVGA+jhO8L
v8/x8M3ibK5ajHB5cTNQmRUgT8v9027/stquS0/8XW5BRzPQ1hy1NNioRpc6JvcF8J8lwp6L
WQQnktDoZhbZ8YVR4y5OR/jLQD1mNLerkFHAR4X5qL0sFSYj53g49mwsarDm7haAcQsloIcM
JDehGbDbccIyH8w+zcWArQIZ9sxXRVvc3RbXLXgNP7cdBqWznBtN5wsO+jFriEmu01wXRu0C
qi+fn66vPqL39a7DbbBZ++P9u9V+/ePzz7vbz2vjjB2Mr1Y8lk/25/M4tFy+SAuVp2nHEwID
x6dG5Q5pUZT3rF2E9i2L/WIkLVK6v3uLzhb3l7d0h5o1/sM8nW6d6c6gVbHCb/ssNWEyFwCY
dH8HbFmblCLwW05nNlciKhZ8MmY+WNlwnGRSTyICAwIYHWWIRn00tr35URMg/kFDvKBo4AcA
jpWxMJaT6AF8BQJVpGPgMd3TCkroPEUJtRgLUHjTIRaADmqS0SowVYZ4eZLHU0e/lIHwkN3s
euQIXCTrDYBdU3IU9pescpUKuCkH2eCjSQ5fSSPwVkGoyB7mcFloegJ+GnzDcKY6Iw903eEM
Ox5It2ely2B7Rol1pBGkEzyJh2UxVq7huXGeWuQAbLpgWbjk6BiJFl+kY4sRQ1CIobq/auEp
vE7F8KpRyvA+BQd4V7sO6X63Lg+H3d47/nq1yPqpXB1P+/Jggbed6AHQPLI4rbMiGgjiNgPB
dJ6JAr1XWkGPk9APpKI900xogAbAqSQVMAy4zplP61z8vFhoYAxktrdgS3UfMpP0Ei3qTSIJ
ejGDjRQGKDvs/GQJjA1oAXDpOKdjLuBfjZJE2yts8MPN3S0NLL68QdCKto5Ii6IF8fXo1hiD
pifIDsDVSEp6ojP5bTp9tDX1hqZOHRub/uFov6PbeZarhGaSSASB5CKJaepcxnwiU+5YSEW+
pk1wBBrWMe9YgF0dLy7foBYhjYYjvszkwnneM8n4dUGHqgzRcXYIBh2jmHbAEZSMyug4UIYR
BPSxKrOiJjLQ91/aXcJLNw1BXgpayTqgKo+6WhK4u9vAoxTt4+1NvzmZdVvAoMsoj4yFCVgk
w+X9bZtulDN4fZHKumGKhAuFwqtECJqSclJhRlDSVvu0gkVVs7m8DviqKSzyie4gHyzPhgQA
RLGKhGbkXHnEbXujd1KhrUdE3qQfSUoTGROsEJGCeRyJMcCgS5oIenRIqjDvgAANHR7C3aeS
1lTmtnhHeK1parkSL7vt5rjb2zhPc1mND4GHC2p57ti9YUMxZnwJboNDm+oE+HNEmzh5R7sP
OG8mUJmDcXbFViLJgatARNzbV+5lw3FKWvvECYbjeq5szQ2WctMJfVWNtzeUyzCLVBqChbvu
DGlaEfg4/DDb5YqOGzTk/zjDJbUuAw+TIADceX/xk1/Yf3r7JDAstALP8myZ9vF3AFjAUhmB
JU0Q2U02WqGOqWN0uqUCZIg8FtbwAGPGubi/6F5Aqt18YJQgeBqJQtc9y000yqF4bZQcjEgy
v7+9aXGbzmhmMut/w/XESRU4PU6ihVuABOguSnB0lWhQ9FBcXlxQfPpQXH256DDpQ3Hd7dqb
hZ7mHqZpZ1UWwpUTYQrc17y70JrXJkslwblCsJwhu11W3NYObiacGbT91njwz8YxjL/qDa98
yZmv6DgTj3zjl4FGoQNBwHEyWBahr6l4UfumLfvWnDpJdBrm4zPs3/1T7j3Qravv5Uu5PRrg
z3gqvd0rplI74L9yr+ggBKV8un4MTtuJpQQdS1TH971gX/7vqdyuf3mH9eq5p+qNGc+60avz
SPn4XPY795Mbhj46HeoNeu9TLr3yuP70oWNSOGUmodWEL0KABoVtO58kDBDbx9fdZnvsTYQm
06gC2qQoVoxyKoVShRPQYnYyBcrhfnFkM5KUhI7MIPAnjT1job98uaBRa8o5y2g2MLpjqYLR
8Mg329X+lydeTs+rmrO6wnDdTwMjGsWoSgLKqEeqAyDjPK0vINjsX/5Z7UvP32/+tiHGJgjs
08sNZBbNWWakw6XxQLODbznKaSL3R8zlzybjUJw/MTgQXX7fr7ynetWPZtWtjJ3JXs86nuFM
ZjqHK3tgfXvQKRfAQNzmWK7Re//4WL6W20cU7Uai259IbPiwZd/qliKOpAWS7TX8BRqzCNlI
UArHzGj8LIkB2Tw2+g8zRRzRdM+GIubHygEt42Kk5oNLluCoYPCNCD5N+zER24phAooAgIMe
YFuxlCKgcj1BHtvwqMgycAVk/JcwP/e6wUH1WRf3Z2acJMm0R0SZhp+1HOdJTmSAFZwwqq0q
t03F5UChovq3OWmiA4CkSuOTC7MlJzb6W8wnUpswMxEMA2S/jBlKoTaZKjOiN2UmxqDcY99G
lqqrrpRWp58SX3tNk3kxgqXYhGOPFskFME5DVuZD/QQeYB8MDuVZDDAYzkS2Y9j97AVxURhZ
R40OjokvbEjMjKAmIb5fJyiyavOIJ6gTb6RmcFmWfwrFAlF7tf0ZKiGq7guBcK9HNc7W6jho
fpI7QqIy5YUtmajrf4gdVKiuCgn3Y8H9mGKt2au4Y4c8KAnokl1qxa5X6gloC3vYJgbXvxEi
re+QzRghvqhCwsShAsSqXQHBgbNaEQgg5YABjAYTIXLG8F6VpRic3YmuN4vopCh6HcQCHCFS
AXRH3XUvO0mXtXjrsDUnDzFyO4JjA2PktwgJFm7JcYXtrgcE1lN4jYrRoKt0XbeUzVsZhjdI
/eH2JB19Mkwu5XEnp163DdLLg9NN4Vaur2qkDptQNVQY82T28dvqUD56/7bpytf97mnz3Ckf
Oa8Cexe1TezU8yCSBm7EqizO7999/9e/usVvWDxo+3Rym61mYgMmd64w39kOnlQcR4VxK17U
mUAnMJnmnaq2EWo3ClzGNvGTwgbyGDt1C6YquuEkS3+LRo6dZ2BYXIPbxO7ontdgQSCAKAI9
fM1FjooRNmFKtNxdsjnVwTBinSAvRiLAP1CdV+VmhlvEz3J9Oq6+PZemMNUzwahjB1+OZBxE
GgWezupbsuKZTKlIouXZJO8wejUIm9+aNJKOwD9uqe/emjVH5csOkHjUOH0DZPhmdKMOm0Qs
zo21aRT5OWZiacRWq8Hd2QoTN7bjWuazmQ70vW7rX6ufRTTqslanuZq0PaHNWMOBgQokhtvg
U6rNaBO9vGkfJzgp3BGHQWBe6AT9uPZ5TBXlFdfFnEaP2wo/P7u/ufjzthWDJMwTFbZt50+n
HV+Bh4LFJtzuCDDQTuRD6oo4PIxy2ol6UMPijB6iNdnKGs93wuwiM5FsuF+HFwXAbCRiPolY
RqmxsxinWlhD3WVJ8GOdfgoW2/wldS3nfvn3Zt12HxunarOumr1kGBbJbfXJRISpK+YuZjpK
A0dSUQNEYGieHdUddvqzq2pqrQdCffZ+n3erR+NHNk7uHMwC8x1rw6ubm2o8SmG0toA5bD+T
M+ceTQcxyxz5XdsBq8+racB+RMmMYutzeQMWFuQ6cVQPI3mWh5itH0kQXSnOFh4DPI/mPjtX
NY6VIzSvad5OAhfPRVjQcS7fAFGt6lWai7NNg5uKZ5Hw1On1dbc/1kwWbQ5rar1wHdESrSO5
OBCLMFGYVccIsOSOg1cAk2kdcEUuUAg478g7nJfYfNBQij+v+eJ2MEyXP1cHT24Px/3pxRR8
HX4AQz56x/1qe8CpPABYpfcIe9284l/r3bPnY7lfeUE6Zq14yO6fLfKy97J7PIHVfY9Rwc2+
hE9c8Q/1ULk9AnoDgOD9l7cvn83rkUP3bJsuyBR+HWYxNAW4nmieJSnR2kw02R2OTiJf7R+p
zzj7717PtRfqCDtoW+b3PFHRh75OwvWdp2tuh0+otxnWK2rgjOJKVrzWOqqaV4CI9r5TF8A4
uN8JRsuN3KrB1cvt6+k4nLOJWMZpPuSzCRyUuWr5OfFwSDfYjOXq/z/hM107ABv8QpK1OXDk
ag3cRgmb1nS1Mug0V5kokKYuGq6KhUaz9sK7zbmk4Pjb8l1HDcn8rURNPHNJdsrv/ri+/VmM
U0cda6y4mwgrGtsMlDuNrDn8l9Jf1yLkfa+j8d/MfgDg5FjnleZDZrriJA9d0TAXsL+jPaIJ
E0W3p+mQsVOdeuvn3frffaUitsYfSCdLfDCDSRMAGvjuC1M/5tjArEcpFmUedzBf6R1/lN7q
8XGD8GH1bGc9fOpkCmTMdUaDL7yr3tOcM23uiNJjErxgM0fht6Fi7pD2LiwdvbCQlorJPHKU
0ugJ+E+M3kf99IYQbKVG7cK95iIVVZg7AgBLdh/1kK21r6fn4+bptF3j6deK6nGYJ4gC3zyW
KhxJQ6RHCKVo8DzRiASU5NfO0VMRpaGjiAgn17fXfzrqdoCsIldOho0WXy4uDIZzj14q7ip/
ArKWBYuur78ssNqG+fQJZGKcg8eW0FohEr5kte8+zE/sV68/NusDJd6+oyQP2gsfq2P4YDrG
U+89Oz1udmBDz/WLH+i3oCzyvXDzbY85qP3udAT4cTanwX71UnrfTk9PYBj8oWEIaLnDYFpo
DFHIfWrTDQsneUzV6+fA8skEc4pS69CU1kjWirUhfVAJjY1nr2fCO6Y6V8PEG7YZ9PXYBRHY
nv74dcDXt164+oVGcSgRcZKaLy64kDNyc0gdM3/sUCR6mTqECQfmYSqd5jGf0wcfRQ7pFJHC
R1+OhCa4QcKnv2RzFtJ4EUviooTPeB2JUjzLW0XBhjS4pAw0AejrbkPEL29u7y7vKkojUxpf
/TGHa+Kjwhmge+uxRmyUB2SqHoNaGLCkt5svfKlS1/Os3IELTJSDwICdDjKBe4iHZj3arPe7
w+7p6E1+vZb7jzPv+6kEGE3oAjCd495zhk6Cua7hLYhzaZybCbgq4tzX9VQnDFmcLN4uC57M
6wDjEFAacKB2p33HoJxjMFOV8ULeXX1pBdahVcw00ToK/XNrC33LcJTQSXqZRFHuVLdZ+bI7
luhcUIKNzrdGf26oWLPXl8N3ckwaqfqW3YpuLolst4LvvFfmHaWXbAGIb14/eIfXcr15OgdX
zqqJvTzvvkOz2vG+1hrtwSdc714oWrxIPwf7ssSykdL7utvLr1S3zadoQbV/Pa2eYeb+1K3N
4cPewc4WmDf46Rq0wJc5i2LG6fqB1DBxv6ClcekW2mmxTWyWZgvH7aTzaLB6jC2s4TKGriAD
ARuDvovYooizdi5Cpph9c2ltgylNfjtLQpdjE0RDtgPk3Hls24DfKt6DHUhDzKNimsQMLcqV
sxcC83TBiqu7OEIngLYhnV44nxsdc0fBSMSHRpioYaU0X8aGSp5tH/e7zWO7G7hQWeIoBvWZ
o6Cn78RaH3yO4Zn1ZvudVsS0QrQFgJp+qmHCOKRykA41pkIZ9bipimmCGFt2aClV39aQg7PV
KitpSQzqwkDZvFeROEpxTS4Pe7jsDMxQFY1KhwD6pt7AIYGWVjjf/gbsjdFf80TTR4jB0EDd
FI5QsiW7qAGmwxy0BGw6wIEe2fLCav2jh4fVIK9gmfxQnh53JknW3FojM2BqXJ83ND6RoZ8J
+rTNO2jaOttnWg6q/cN9KJg+M9wAH9DCARPicHgsqlyf9pvjLwp9TcXSEYoVPM8AYgKoE8qo
SpMFf7Ov68iwHNq+9pIqCQcVYfXp1EUu+HzU8KMpETAJG2ZrNVpxn143mo06tUf00k267pxI
HWZGahGqMmHNsbBWkq9P7fxWGiOayeBWCBevZ0TgxGMOJxBgJBtXSNRfQZdQxA5qIOP6NeNI
Er+XAws+eyWL5/ehyTAdacq58FeJmF8WkIayW27HAT9yDu4hzd0Zv6QfMeA4fXnhSzojjWSp
88I57TVt+IBySz/hAoqTQAc0wAsyH3LVZ3P6jZcNIF5fYZI66P8yowZ3PeCTZlIgFN5DOwVt
m9BuFL1KU9V9zmvSrcq4ZOBLxmM9cZSl2gq/icD8bYuhodUHcMw12qXOLYMxcwAS36ctiPmt
Oom77NuUNvxfIVey2zYMRO/9ihx7aIskDdBecqAdL0K0RbKj3oTUNdzASBo0CdDP7ywkJVIz
9KkLx5Q4pGaG5HsPt0EmK0OwVQM5T3TehxF///fD7shwGPrfl7+Pz29HOuj89bSH3cEEMgB/
QBjCpLoi9qmnBH1TLe622WJzfeWBLJDKMahNergK5Lw+k/QL5KTd8ZVeaGdlvqRIzJeOqK0l
19cWG09n0XjiLXiTmZ6dacrri/PLq9CTdW/aolflHBAhQ08wrVxJbUsIMngyV8wqRU6CeS9d
mbx3DZOEW5ILPKpseWTjNcC/aRnLiimwwGNZLQsFRuSIvipz6ZgkIMVOH0iKTX23MLcOsyCn
ZIPbDsjHjaRRwV0xtMxdaVlEy83+5/vhEHPD0H1E/23VSi7kZ+uzACNrq1IrGbmbpkLtqInK
WmRVzRBJLE4aIYR5kBClcvDW1JOuJfEEhkhu2wg4Elndq7QNCn5sw6jz6VvYhkT3FkCEOj8J
qwR7bXAGjQfL1GVOemHScF2z0NPAgEc0H4tM1HOhn3V0226hIbCyzvI/u+P7Cwed9cPzITod
WG4iILFcrk4Bx4prsBGqWwjWiL0Wjbo78UZltGpL+JTg862ijZDU7mlqQSPeZSEybUReYho8
LzCUW5hEzsin2MXtYlFLClvo0+HDPfv4+vL4TFdjn86e3t/2//bwFyTnfCF6jqsccGtHfa8o
l/nT1/GG4j69waM+sFBNfUPCsV+8wlHLKIl46To2Qu2YrjbKrplt6aX0IMRG7hw6B5ee6Au9
Y+rMZ3v5PempsA5JoEENXMM4UnXXoOEid4LZAwaIcmZQTCEwU7/ftrGOY2VqpFky1tbZKYs2
FdAdrSA1x/MGxlJuMiNsFFFDTsxMqBhH/AHVmWhxcl7ISHU4ydLd2VCeWqVWULFv9MTsPBGz
YZQTDty7iTau9vG0CUXzJ6TgkFFMPPCtq8bUa9nGMVhEhk/YSPwCiedhmwuGnkMJDwV7zIFg
Gia/AzNWYiaG/WHhQO22EX+hxLGlPrOWGZiY2QbpDwUvHew/vpcZnyWry4uqlZIEMRUu8vDt
m6KWMeoDKP92dRPcfeG/UyXIdgYpG9N2tkGVP4bfD+UztqYrGDz2RFVfwjmOpc14RiHbL3Oz
aiXn410TVBSzqiUi7kbROWRwa0JJj+6sNieglZ18NsqsHV1QzGbYfEYqj5rriyKrlI8sq1g7
ii5q+/Mf389HYsZR22Kk/BC2bVl/6lJuJcLP10kbPWxMbB0aFKkzb8HPS9uUEaTWe8yGpvEr
jsubeW0SH5UXnHSqT4lpgZSgXNF45ZF+GQZbvy/sshI2b/qWyluguFDwzf0HXcWzGVpbAAA=

--9amGYk9869ThD9tj--
