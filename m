Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCD7C282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 16:06:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D312207E0
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 16:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731657AbfA3QGN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 11:06:13 -0500
Received: from mga06.intel.com ([134.134.136.31]:59558 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731234AbfA3QGN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 11:06:13 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2019 08:06:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,541,1539673200"; 
   d="gz'50?scan'50,208,50";a="316180418"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 30 Jan 2019 08:06:09 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1gosNM-000DrJ-B0; Thu, 31 Jan 2019 00:06:08 +0800
Date:   Thu, 31 Jan 2019 00:05:35 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Balaji Pothunoori <bpothuno@codeaurora.org>
Cc:     kbuild-all@01.org, johannes@sipsolutions.net,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Ashok Raj Nagarajan <arnagara@codeaurora.org>,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: Re: [PATCH v2 2/3] mac80211: store tx power value from user to
 station
Message-ID: <201901310024.zKAPP0KW%fengguang.wu@intel.com>
References: <1548844520-13752-1-git-send-email-bpothuno@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1548844520-13752-1-git-send-email-bpothuno@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Ashok,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mac80211-next/master]
[also build test WARNING on next-20190130]
[cannot apply to v5.0-rc4]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Balaji-Pothunoori/cfg80211-Add-support-to-set-tx-power-for-a-station-associated/20190130-192343
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   WARNING: convert(1) not found, for SVG to PDF conversion install ImageMagick (https://www.imagemagick.org)
   include/linux/interrupt.h:268: warning: Function parameter or member 'is_managed' not described in 'irq_affinity_desc'
   include/linux/rcupdate_wait.h:1: warning: no structured comments found
   include/linux/rcutree.h:1: warning: no structured comments found
   kernel/rcu/tree.c:710: warning: Excess function parameter 'irq' description in 'rcu_nmi_exit'
   include/linux/gfp.h:1: warning: no structured comments found
   include/net/cfg80211.h:4737: warning: Function parameter or member 'wext.ibss' not described in 'wireless_dev'
   include/net/cfg80211.h:4737: warning: Function parameter or member 'wext.connect' not described in 'wireless_dev'
   include/net/cfg80211.h:4737: warning: Function parameter or member 'wext.keys' not described in 'wireless_dev'
   include/net/cfg80211.h:4737: warning: Function parameter or member 'wext.ie' not described in 'wireless_dev'
   include/net/cfg80211.h:4737: warning: Function parameter or member 'wext.ie_len' not described in 'wireless_dev'
   include/net/cfg80211.h:4737: warning: Function parameter or member 'wext.bssid' not described in 'wireless_dev'
   include/net/cfg80211.h:4737: warning: Function parameter or member 'wext.ssid' not described in 'wireless_dev'
   include/net/cfg80211.h:4737: warning: Function parameter or member 'wext.default_key' not described in 'wireless_dev'
   include/net/cfg80211.h:4737: warning: Function parameter or member 'wext.default_mgmt_key' not described in 'wireless_dev'
   include/net/cfg80211.h:4737: warning: Function parameter or member 'wext.prev_bssid_valid' not described in 'wireless_dev'
   include/net/cfg80211.h:1064: warning: Function parameter or member 'txpwr' not described in 'station_parameters'
   include/net/cfg80211.h:1064: warning: Function parameter or member 'txpwr.power' not described in 'station_parameters'
   include/net/cfg80211.h:1064: warning: Function parameter or member 'txpwr.type' not described in 'station_parameters'
   include/net/cfg80211.h:1471: warning: Enum value 'MPATH_INFO_PATH_CHANGE' not described in enum 'mpath_info_flags'
   include/net/mac80211.h:2418: warning: Function parameter or member 'radiotap_timestamp.units_pos' not described in 'ieee80211_hw'
   include/net/mac80211.h:2418: warning: Function parameter or member 'radiotap_timestamp.accuracy' not described in 'ieee80211_hw'
   include/net/mac80211.h:2418: warning: Function parameter or member 'weight_multiplier' not described in 'ieee80211_hw'
>> include/net/mac80211.h:3957: warning: Function parameter or member 'sta_set_txpwr' not described in 'ieee80211_ops'
   include/net/mac80211.h:1010: warning: Function parameter or member 'control.rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1010: warning: Function parameter or member 'control.rts_cts_rate_idx' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1010: warning: Function parameter or member 'control.use_rts' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1010: warning: Function parameter or member 'control.use_cts_prot' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1010: warning: Function parameter or member 'control.short_preamble' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1010: warning: Function parameter or member 'control.skip_table' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1010: warning: Function parameter or member 'control.jiffies' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1010: warning: Function parameter or member 'control.vif' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1010: warning: Function parameter or member 'control.hw_key' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1010: warning: Function parameter or member 'control.flags' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1010: warning: Function parameter or member 'control.enqueue_time' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1010: warning: Function parameter or member 'ack' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1010: warning: Function parameter or member 'ack.cookie' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1010: warning: Function parameter or member 'status.rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1010: warning: Function parameter or member 'status.ack_signal' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1010: warning: Function parameter or member 'status.ampdu_ack_len' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1010: warning: Function parameter or member 'status.ampdu_len' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1010: warning: Function parameter or member 'status.antenna' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1010: warning: Function parameter or member 'status.tx_time' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1010: warning: Function parameter or member 'status.is_valid_ack_signal' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1010: warning: Function parameter or member 'status.status_driver_data' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1010: warning: Function parameter or member 'driver_rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1010: warning: Function parameter or member 'pad' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1010: warning: Function parameter or member 'rate_driver_data' not described in 'ieee80211_tx_info'
>> include/net/mac80211.h:1947: warning: Function parameter or member 'txpwr' not described in 'ieee80211_sta'
>> include/net/mac80211.h:1947: warning: Function parameter or member 'txpwr.power' not described in 'ieee80211_sta'
>> include/net/mac80211.h:1947: warning: Function parameter or member 'txpwr.type' not described in 'ieee80211_sta'
   net/mac80211/sta_info.h:607: warning: Function parameter or member 'rx_stats_avg' not described in 'sta_info'
   net/mac80211/sta_info.h:607: warning: Function parameter or member 'rx_stats_avg.signal' not described in 'sta_info'
   net/mac80211/sta_info.h:607: warning: Function parameter or member 'rx_stats_avg.chain_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:607: warning: Function parameter or member 'status_stats.filtered' not described in 'sta_info'
   net/mac80211/sta_info.h:607: warning: Function parameter or member 'status_stats.retry_failed' not described in 'sta_info'
   net/mac80211/sta_info.h:607: warning: Function parameter or member 'status_stats.retry_count' not described in 'sta_info'
   net/mac80211/sta_info.h:607: warning: Function parameter or member 'status_stats.lost_packets' not described in 'sta_info'
   net/mac80211/sta_info.h:607: warning: Function parameter or member 'status_stats.last_tdls_pkt_time' not described in 'sta_info'
   net/mac80211/sta_info.h:607: warning: Function parameter or member 'status_stats.msdu_retries' not described in 'sta_info'
   net/mac80211/sta_info.h:607: warning: Function parameter or member 'status_stats.msdu_failed' not described in 'sta_info'
   net/mac80211/sta_info.h:607: warning: Function parameter or member 'status_stats.last_ack' not described in 'sta_info'
   net/mac80211/sta_info.h:607: warning: Function parameter or member 'status_stats.last_ack_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:607: warning: Function parameter or member 'status_stats.ack_signal_filled' not described in 'sta_info'
   net/mac80211/sta_info.h:607: warning: Function parameter or member 'status_stats.avg_ack_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:607: warning: Function parameter or member 'tx_stats.packets' not described in 'sta_info'
   net/mac80211/sta_info.h:607: warning: Function parameter or member 'tx_stats.bytes' not described in 'sta_info'
   net/mac80211/sta_info.h:607: warning: Function parameter or member 'tx_stats.last_rate' not described in 'sta_info'
   net/mac80211/sta_info.h:607: warning: Function parameter or member 'tx_stats.msdu' not described in 'sta_info'
   net/mac80211/sta_info.h:607: warning: Function parameter or member 'airtime' not described in 'sta_info'
   net/mac80211/sta_info.h:607: warning: Function parameter or member 'airtime_weight' not described in 'sta_info'
   kernel/rcu/tree.c:711: warning: Excess function parameter 'irq' description in 'rcu_nmi_exit'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.active' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.active' not described in 'dma_buf'
   include/linux/dma-fence-array.h:54: warning: Function parameter or member 'work' not described in 'dma_fence_array'
   include/linux/firmware/intel/stratix10-svc-client.h:1: warning: no structured comments found
   include/linux/gpio/driver.h:371: warning: Function parameter or member 'init_valid_mask' not described in 'gpio_chip'
   include/linux/iio/hw-consumer.h:1: warning: no structured comments found
   include/linux/input/sparse-keymap.h:46: warning: Function parameter or member 'sw' not described in 'key_entry'
   drivers/mtd/nand/raw/nand_base.c:420: warning: Function parameter or member 'chip' not described in 'nand_fill_oob'
   drivers/mtd/nand/raw/nand_bbt.c:173: warning: Function parameter or member 'this' not described in 'read_bbt'
   drivers/mtd/nand/raw/nand_bbt.c:173: warning: Excess function parameter 'chip' description in 'read_bbt'
   include/linux/regulator/machine.h:199: warning: Function parameter or member 'max_uV_step' not described in 'regulation_constraints'
   include/linux/regulator/driver.h:228: warning: Function parameter or member 'resume' not described in 'regulator_ops'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw0' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw1' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw2' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw3' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.eadm' not described in 'irb'
   drivers/slimbus/stream.c:1: warning: no structured comments found
   include/linux/spi/spi.h:180: warning: Function parameter or member 'driver_override' not described in 'spi_device'
   drivers/target/target_core_device.c:1: warning: no structured comments found
   drivers/usb/typec/bus.c:1: warning: no structured comments found
   drivers/usb/typec/class.c:1: warning: no structured comments found
   include/linux/w1.h:281: warning: Function parameter or member 'of_match_table' not described in 'w1_family'
   fs/direct-io.c:257: warning: Excess function parameter 'offset' description in 'dio_complete'
   fs/file_table.c:1: warning: no structured comments found
   fs/libfs.c:477: warning: Excess function parameter 'available' description in 'simple_write_end'
   fs/posix_acl.c:646: warning: Function parameter or member 'inode' not described in 'posix_acl_update_mode'
   fs/posix_acl.c:646: warning: Function parameter or member 'mode_p' not described in 'posix_acl_update_mode'
   fs/posix_acl.c:646: warning: Function parameter or member 'acl' not described in 'posix_acl_update_mode'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:294: warning: Excess function parameter 'mm' description in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:294: warning: Excess function parameter 'start' description in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:294: warning: Excess function parameter 'end' description in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:343: warning: Excess function parameter 'mm' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:343: warning: Excess function parameter 'start' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:343: warning: Excess function parameter 'end' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:183: warning: Function parameter or member 'blockable' not described in 'amdgpu_mn_read_lock'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:295: warning: Function parameter or member 'range' not described in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:295: warning: Excess function parameter 'mm' description in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:295: warning: Excess function parameter 'start' description in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:295: warning: Excess function parameter 'end' description in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:344: warning: Function parameter or member 'range' not described in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:344: warning: Excess function parameter 'mm' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:344: warning: Excess function parameter 'start' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:344: warning: Excess function parameter 'end' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:382: warning: cannot understand function prototype: 'struct amdgpu_vm_pt_cursor '
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:383: warning: cannot understand function prototype: 'struct amdgpu_vm_pt_cursor '
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'adev' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'vm' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'start' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'end' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'cursor' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:603: warning: Function parameter or member 'adev' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:603: warning: Function parameter or member 'vm' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:603: warning: Function parameter or member 'cursor' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:603: warning: Function parameter or member 'entry' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:845: warning: Function parameter or member 'level' not described in 'amdgpu_vm_bo_param'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1350: warning: Function parameter or member 'params' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1350: warning: Function parameter or member 'bo' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1350: warning: Function parameter or member 'pe' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1350: warning: Function parameter or member 'addr' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1350: warning: Function parameter or member 'count' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1350: warning: Function parameter or member 'incr' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1350: warning: Function parameter or member 'flags' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1517: warning: Function parameter or member 'params' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1517: warning: Function parameter or member 'bo' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1517: warning: Function parameter or member 'level' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1517: warning: Function parameter or member 'pe' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1517: warning: Function parameter or member 'addr' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1517: warning: Function parameter or member 'count' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1517: warning: Function parameter or member 'incr' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1517: warning: Function parameter or member 'flags' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:3093: warning: Function parameter or member 'pasid' not described in 'amdgpu_vm_make_compute'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:128: warning: Incorrect use of kernel-doc format: Documentation Makefile include scripts source @atomic_obj
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:203: warning: Function parameter or member 'atomic_obj' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:203: warning: Function parameter or member 'atomic_obj_lock' not described in 'amdgpu_display_manager'

vim +3957 include/net/mac80211.h

cf2c92d840 Eliad Peller           2014-11-04  3126  
cf2c92d840 Eliad Peller           2014-11-04  3127  /**
75a5f0ccfd Johannes Berg          2007-09-18  3128   * struct ieee80211_ops - callbacks from mac80211 to the driver
75a5f0ccfd Johannes Berg          2007-09-18  3129   *
75a5f0ccfd Johannes Berg          2007-09-18  3130   * This structure contains various callbacks that the driver may
75a5f0ccfd Johannes Berg          2007-09-18  3131   * handle or, in some cases, must handle, for example to configure
75a5f0ccfd Johannes Berg          2007-09-18  3132   * the hardware to a new channel or to transmit a frame.
75a5f0ccfd Johannes Berg          2007-09-18  3133   *
75a5f0ccfd Johannes Berg          2007-09-18  3134   * @tx: Handler that 802.11 module calls for each transmitted frame.
f0706e828e Jiri Benc              2007-05-05  3135   *	skb contains the buffer starting from the IEEE 802.11 header.
f0706e828e Jiri Benc              2007-05-05  3136   *	The low-level driver should send the frame out based on
eefce91a38 Johannes Berg          2008-05-17  3137   *	configuration in the TX control data. This handler should,
11127e9121 Johannes Berg          2011-11-16  3138   *	preferably, never fail and stop queues appropriately.
11127e9121 Johannes Berg          2011-11-16  3139   *	Must be atomic.
75a5f0ccfd Johannes Berg          2007-09-18  3140   *
75a5f0ccfd Johannes Berg          2007-09-18  3141   * @start: Called before the first netdevice attached to the hardware
4150c57212 Johannes Berg          2007-09-17  3142   *	is enabled. This should turn on the hardware and must turn on
4150c57212 Johannes Berg          2007-09-17  3143   *	frame reception (for possibly enabled monitor interfaces.)
4150c57212 Johannes Berg          2007-09-17  3144   *	Returns negative error codes, these may be seen in userspace,
4150c57212 Johannes Berg          2007-09-17  3145   *	or zero.
4150c57212 Johannes Berg          2007-09-17  3146   *	When the device is started it should not have a MAC address
4150c57212 Johannes Berg          2007-09-17  3147   *	to avoid acknowledging frames before a non-monitor device
4150c57212 Johannes Berg          2007-09-17  3148   *	is added.
e1781ed33a Kalle Valo             2009-12-23  3149   *	Must be implemented and can sleep.
75a5f0ccfd Johannes Berg          2007-09-18  3150   *
75a5f0ccfd Johannes Berg          2007-09-18  3151   * @stop: Called after last netdevice attached to the hardware
4150c57212 Johannes Berg          2007-09-17  3152   *	is disabled. This should turn off the hardware (at least
4150c57212 Johannes Berg          2007-09-17  3153   *	it must turn off frame reception.)
4150c57212 Johannes Berg          2007-09-17  3154   *	May be called right after add_interface if that rejects
42935ecaf4 Luis R. Rodriguez      2009-07-29  3155   *	an interface. If you added any work onto the mac80211 workqueue
42935ecaf4 Luis R. Rodriguez      2009-07-29  3156   *	you should ensure to cancel it on this callback.
e1781ed33a Kalle Valo             2009-12-23  3157   *	Must be implemented and can sleep.
75a5f0ccfd Johannes Berg          2007-09-18  3158   *
eecc48000a Johannes Berg          2011-05-04  3159   * @suspend: Suspend the device; mac80211 itself will quiesce before and
eecc48000a Johannes Berg          2011-05-04  3160   *	stop transmitting and doing any other configuration, and then
eecc48000a Johannes Berg          2011-05-04  3161   *	ask the device to suspend. This is only invoked when WoWLAN is
eecc48000a Johannes Berg          2011-05-04  3162   *	configured, otherwise the device is deconfigured completely and
eecc48000a Johannes Berg          2011-05-04  3163   *	reconfigured at resume time.
2b4562dfd6 Johannes Berg          2011-07-02  3164   *	The driver may also impose special conditions under which it
2b4562dfd6 Johannes Berg          2011-07-02  3165   *	wants to use the "normal" suspend (deconfigure), say if it only
2b4562dfd6 Johannes Berg          2011-07-02  3166   *	supports WoWLAN when the device is associated. In this case, it
2b4562dfd6 Johannes Berg          2011-07-02  3167   *	must return 1 from this function.
eecc48000a Johannes Berg          2011-05-04  3168   *
eecc48000a Johannes Berg          2011-05-04  3169   * @resume: If WoWLAN was configured, this indicates that mac80211 is
eecc48000a Johannes Berg          2011-05-04  3170   *	now resuming its operation, after this the device must be fully
eecc48000a Johannes Berg          2011-05-04  3171   *	functional again. If this returns an error, the only way out is
eecc48000a Johannes Berg          2011-05-04  3172   *	to also unregister the device. If it returns 1, then mac80211
eecc48000a Johannes Berg          2011-05-04  3173   *	will also go through the regular complete restart on resume.
eecc48000a Johannes Berg          2011-05-04  3174   *
d13e141481 Johannes Berg          2012-06-09  3175   * @set_wakeup: Enable or disable wakeup when WoWLAN configuration is
d13e141481 Johannes Berg          2012-06-09  3176   *	modified. The reason is that device_set_wakeup_enable() is
d13e141481 Johannes Berg          2012-06-09  3177   *	supposed to be called when the configuration changes, not only
d13e141481 Johannes Berg          2012-06-09  3178   *	in suspend().
d13e141481 Johannes Berg          2012-06-09  3179   *
75a5f0ccfd Johannes Berg          2007-09-18  3180   * @add_interface: Called when a netdevice attached to the hardware is
e37d4dffdf Bob Copeland           2008-10-20  3181   *	enabled. Because it is not called for monitor mode devices, @start
75a5f0ccfd Johannes Berg          2007-09-18  3182   *	and @stop must be implemented.
4150c57212 Johannes Berg          2007-09-17  3183   *	The driver should perform any initialization it needs before
4150c57212 Johannes Berg          2007-09-17  3184   *	the device can be enabled. The initial configuration for the
4150c57212 Johannes Berg          2007-09-17  3185   *	interface is given in the conf parameter.
75a5f0ccfd Johannes Berg          2007-09-18  3186   *	The callback may refuse to add an interface by returning a
75a5f0ccfd Johannes Berg          2007-09-18  3187   *	negative error code (which will be seen in userspace.)
e1781ed33a Kalle Valo             2009-12-23  3188   *	Must be implemented and can sleep.
75a5f0ccfd Johannes Berg          2007-09-18  3189   *
34d4bc4d41 Johannes Berg          2010-08-27  3190   * @change_interface: Called when a netdevice changes type. This callback
34d4bc4d41 Johannes Berg          2010-08-27  3191   *	is optional, but only if it is supported can interface types be
34d4bc4d41 Johannes Berg          2010-08-27  3192   *	switched while the interface is UP. The callback may sleep.
34d4bc4d41 Johannes Berg          2010-08-27  3193   *	Note that while an interface is being switched, it will not be
34d4bc4d41 Johannes Berg          2010-08-27  3194   *	found by the interface iteration callbacks.
34d4bc4d41 Johannes Berg          2010-08-27  3195   *
75a5f0ccfd Johannes Berg          2007-09-18  3196   * @remove_interface: Notifies a driver that an interface is going down.
75a5f0ccfd Johannes Berg          2007-09-18  3197   *	The @stop callback is called after this if it is the last interface
75a5f0ccfd Johannes Berg          2007-09-18  3198   *	and no monitor interfaces are present.
4150c57212 Johannes Berg          2007-09-17  3199   *	When all interfaces are removed, the MAC address in the hardware
4150c57212 Johannes Berg          2007-09-17  3200   *	must be cleared so the device no longer acknowledges packets,
4150c57212 Johannes Berg          2007-09-17  3201   *	the mac_addr member of the conf structure is, however, set to the
4150c57212 Johannes Berg          2007-09-17  3202   *	MAC address of the device going away.
e1781ed33a Kalle Valo             2009-12-23  3203   *	Hence, this callback must be implemented. It can sleep.
4150c57212 Johannes Berg          2007-09-17  3204   *
75a5f0ccfd Johannes Berg          2007-09-18  3205   * @config: Handler for configuration requests. IEEE 802.11 code calls this
75a5f0ccfd Johannes Berg          2007-09-18  3206   *	function to change hardware configuration, e.g., channel.
6dd1bf3118 Bob Copeland           2009-01-08  3207   *	This function should never fail but returns a negative error code
e1781ed33a Kalle Valo             2009-12-23  3208   *	if it does. The callback can sleep.
4150c57212 Johannes Berg          2007-09-17  3209   *
471b3efdfc Johannes Berg          2007-12-28  3210   * @bss_info_changed: Handler for configuration requests related to BSS
471b3efdfc Johannes Berg          2007-12-28  3211   *	parameters that may vary during BSS's lifespan, and may affect low
471b3efdfc Johannes Berg          2007-12-28  3212   *	level driver (e.g. assoc/disassoc status, erp parameters).
471b3efdfc Johannes Berg          2007-12-28  3213   *	This function should not be used if no BSS has been set, unless
471b3efdfc Johannes Berg          2007-12-28  3214   *	for association indication. The @changed parameter indicates which
e1781ed33a Kalle Valo             2009-12-23  3215   *	of the bss parameters has changed when a call is made. The callback
e1781ed33a Kalle Valo             2009-12-23  3216   *	can sleep.
471b3efdfc Johannes Berg          2007-12-28  3217   *
3ac64beecd Johannes Berg          2009-08-17  3218   * @prepare_multicast: Prepare for multicast filter configuration.
3ac64beecd Johannes Berg          2009-08-17  3219   *	This callback is optional, and its return value is passed
3ac64beecd Johannes Berg          2009-08-17  3220   *	to configure_filter(). This callback must be atomic.
3ac64beecd Johannes Berg          2009-08-17  3221   *
75a5f0ccfd Johannes Berg          2007-09-18  3222   * @configure_filter: Configure the device's RX filter.
75a5f0ccfd Johannes Berg          2007-09-18  3223   *	See the section "Frame filtering" for more information.
e1781ed33a Kalle Valo             2009-12-23  3224   *	This callback must be implemented and can sleep.
8f20fc2498 Johannes Berg          2007-08-28  3225   *
1b09b5568e Andrei Otcheretianski  2015-08-15  3226   * @config_iface_filter: Configure the interface's RX filter.
1b09b5568e Andrei Otcheretianski  2015-08-15  3227   *	This callback is optional and is used to configure which frames
1b09b5568e Andrei Otcheretianski  2015-08-15  3228   *	should be passed to mac80211. The filter_flags is the combination
1b09b5568e Andrei Otcheretianski  2015-08-15  3229   *	of FIF_* flags. The changed_flags is a bit mask that indicates
1b09b5568e Andrei Otcheretianski  2015-08-15  3230   *	which flags are changed.
1b09b5568e Andrei Otcheretianski  2015-08-15  3231   *	This callback can sleep.
1b09b5568e Andrei Otcheretianski  2015-08-15  3232   *
546c80c91f Luis R. Rodriguez      2008-08-14  3233   * @set_tim: Set TIM bit. mac80211 calls this function when a TIM bit
17741cdc26 Johannes Berg          2008-09-11  3234   * 	must be set or cleared for a given STA. Must be atomic.
11a843b7e1 Johannes Berg          2007-08-28  3235   *
75a5f0ccfd Johannes Berg          2007-09-18  3236   * @set_key: See the section "Hardware crypto acceleration"
e1781ed33a Kalle Valo             2009-12-23  3237   *	This callback is only called between add_interface and
e1781ed33a Kalle Valo             2009-12-23  3238   *	remove_interface calls, i.e. while the given virtual interface
dc822b5db4 Johannes Berg          2008-12-29  3239   *	is enabled.
6dd1bf3118 Bob Copeland           2009-01-08  3240   *	Returns a negative error code if the key can't be added.
e1781ed33a Kalle Valo             2009-12-23  3241   *	The callback can sleep.
11a843b7e1 Johannes Berg          2007-08-28  3242   *
9ae4fda332 Emmanuel Grumbach      2008-03-20  3243   * @update_tkip_key: See the section "Hardware crypto acceleration"
9ae4fda332 Emmanuel Grumbach      2008-03-20  3244   * 	This callback will be called in the context of Rx. Called for drivers
9ae4fda332 Emmanuel Grumbach      2008-03-20  3245   * 	which set IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY.
eb807fb238 Kalle Valo             2010-01-24  3246   *	The callback must be atomic.
9ae4fda332 Emmanuel Grumbach      2008-03-20  3247   *
c68f4b892c Johannes Berg          2011-07-05  3248   * @set_rekey_data: If the device supports GTK rekeying, for example while the
c68f4b892c Johannes Berg          2011-07-05  3249   *	host is suspended, it can assign this callback to retrieve the data
c68f4b892c Johannes Berg          2011-07-05  3250   *	necessary to do GTK rekeying, this is the KEK, KCK and replay counter.
c68f4b892c Johannes Berg          2011-07-05  3251   *	After rekeying was done it should (for example during resume) notify
c68f4b892c Johannes Berg          2011-07-05  3252   *	userspace of the new replay counter using ieee80211_gtk_rekey_notify().
c68f4b892c Johannes Berg          2011-07-05  3253   *
de5fad8157 Yoni Divinsky          2012-05-30  3254   * @set_default_unicast_key: Set the default (unicast) key index, useful for
de5fad8157 Yoni Divinsky          2012-05-30  3255   *	WEP when the device sends data packets autonomously, e.g. for ARP
de5fad8157 Yoni Divinsky          2012-05-30  3256   *	offloading. The index can be 0-3, or -1 for unsetting it.
de5fad8157 Yoni Divinsky          2012-05-30  3257   *
75a5f0ccfd Johannes Berg          2007-09-18  3258   * @hw_scan: Ask the hardware to service the scan request, no need to start
8318d78a44 Johannes Berg          2008-01-24  3259   *	the scan state machine in stack. The scan must honour the channel
9050bdd858 Kalle Valo             2009-03-22  3260   *	configuration done by the regulatory agent in the wiphy's
9050bdd858 Kalle Valo             2009-03-22  3261   *	registered bands. The hardware (or the driver) needs to make sure
de95a54b1a Johannes Berg          2009-04-01  3262   *	that power save is disabled.
de95a54b1a Johannes Berg          2009-04-01  3263   *	The @req ie/ie_len members are rewritten by mac80211 to contain the
de95a54b1a Johannes Berg          2009-04-01  3264   *	entire IEs after the SSID, so that drivers need not look at these
de95a54b1a Johannes Berg          2009-04-01  3265   *	at all but just send them after the SSID -- mac80211 includes the
de95a54b1a Johannes Berg          2009-04-01  3266   *	(extended) supported rates and HT information (where applicable).
de95a54b1a Johannes Berg          2009-04-01  3267   *	When the scan finishes, ieee80211_scan_completed() must be called;
de95a54b1a Johannes Berg          2009-04-01  3268   *	note that it also must be called when the scan cannot finish due to
de95a54b1a Johannes Berg          2009-04-01  3269   *	any error unless this callback returned a negative error code.
e9da68ddea Johannes Berg          2018-10-18  3270   *	This callback is also allowed to return the special return value 1,
e9da68ddea Johannes Berg          2018-10-18  3271   *	this indicates that hardware scan isn't desirable right now and a
e9da68ddea Johannes Berg          2018-10-18  3272   *	software scan should be done instead. A driver wishing to use this
e9da68ddea Johannes Berg          2018-10-18  3273   *	capability must ensure its (hardware) scan capabilities aren't
e9da68ddea Johannes Berg          2018-10-18  3274   *	advertised as more capable than mac80211's software scan is.
e1781ed33a Kalle Valo             2009-12-23  3275   *	The callback can sleep.
11a843b7e1 Johannes Berg          2007-08-28  3276   *
b856439b1b Eliad Peller           2011-06-13  3277   * @cancel_hw_scan: Ask the low-level tp cancel the active hw scan.
b856439b1b Eliad Peller           2011-06-13  3278   *	The driver should ask the hardware to cancel the scan (if possible),
b856439b1b Eliad Peller           2011-06-13  3279   *	but the scan will be completed only after the driver will call
b856439b1b Eliad Peller           2011-06-13  3280   *	ieee80211_scan_completed().
b856439b1b Eliad Peller           2011-06-13  3281   *	This callback is needed for wowlan, to prevent enqueueing a new
b856439b1b Eliad Peller           2011-06-13  3282   *	scan_work after the low-level driver was already suspended.
b856439b1b Eliad Peller           2011-06-13  3283   *	The callback can sleep.
b856439b1b Eliad Peller           2011-06-13  3284   *
79f460ca49 Luciano Coelho         2011-05-11  3285   * @sched_scan_start: Ask the hardware to start scanning repeatedly at
79f460ca49 Luciano Coelho         2011-05-11  3286   *	specific intervals.  The driver must call the
79f460ca49 Luciano Coelho         2011-05-11  3287   *	ieee80211_sched_scan_results() function whenever it finds results.
79f460ca49 Luciano Coelho         2011-05-11  3288   *	This process will continue until sched_scan_stop is called.
79f460ca49 Luciano Coelho         2011-05-11  3289   *
79f460ca49 Luciano Coelho         2011-05-11  3290   * @sched_scan_stop: Tell the hardware to stop an ongoing scheduled scan.
37e3308cb2 Johannes Berg          2014-02-17  3291   *	In this case, ieee80211_sched_scan_stopped() must not be called.
79f460ca49 Luciano Coelho         2011-05-11  3292   *
80e775bf08 Michael Buesch         2009-02-20  3293   * @sw_scan_start: Notifier function that is called just before a software scan
80e775bf08 Michael Buesch         2009-02-20  3294   *	is started. Can be NULL, if the driver doesn't need this notification.
a344d6778a Johannes Berg          2014-06-12  3295   *	The mac_addr parameter allows supporting NL80211_SCAN_FLAG_RANDOM_ADDR,
a344d6778a Johannes Berg          2014-06-12  3296   *	the driver may set the NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR flag if it
a344d6778a Johannes Berg          2014-06-12  3297   *	can use this parameter. The callback can sleep.
80e775bf08 Michael Buesch         2009-02-20  3298   *
e1781ed33a Kalle Valo             2009-12-23  3299   * @sw_scan_complete: Notifier function that is called just after a
e1781ed33a Kalle Valo             2009-12-23  3300   *	software scan finished. Can be NULL, if the driver doesn't need
e1781ed33a Kalle Valo             2009-12-23  3301   *	this notification.
e1781ed33a Kalle Valo             2009-12-23  3302   *	The callback can sleep.
80e775bf08 Michael Buesch         2009-02-20  3303   *
6dd1bf3118 Bob Copeland           2009-01-08  3304   * @get_stats: Return low-level statistics.
6dd1bf3118 Bob Copeland           2009-01-08  3305   * 	Returns zero if statistics are available.
e1781ed33a Kalle Valo             2009-12-23  3306   *	The callback can sleep.
7ac1bd6aec Johannes Berg          2007-09-14  3307   *
9352c19f63 Johannes Berg          2015-04-20  3308   * @get_key_seq: If your device implements encryption in hardware and does
9352c19f63 Johannes Berg          2015-04-20  3309   *	IV/PN assignment then this callback should be provided to read the
9352c19f63 Johannes Berg          2015-04-20  3310   *	IV/PN for the given key from hardware.
e1781ed33a Kalle Valo             2009-12-23  3311   *	The callback must be atomic.
75a5f0ccfd Johannes Berg          2007-09-18  3312   *
f23a478075 Arik Nemtsov           2010-11-08  3313   * @set_frag_threshold: Configuration of fragmentation threshold. Assign this
f3fe4e93dd Sara Sharon            2016-10-18  3314   *	if the device does fragmentation by itself. Note that to prevent the
f3fe4e93dd Sara Sharon            2016-10-18  3315   *	stack from doing fragmentation IEEE80211_HW_SUPPORTS_TX_FRAG
f3fe4e93dd Sara Sharon            2016-10-18  3316   *	should be set as well.
f23a478075 Arik Nemtsov           2010-11-08  3317   *	The callback can sleep.
f23a478075 Arik Nemtsov           2010-11-08  3318   *
75a5f0ccfd Johannes Berg          2007-09-18  3319   * @set_rts_threshold: Configuration of RTS threshold (if device needs it)
e1781ed33a Kalle Valo             2009-12-23  3320   *	The callback can sleep.
75a5f0ccfd Johannes Berg          2007-09-18  3321   *
34e895075e Johannes Berg          2010-02-03  3322   * @sta_add: Notifies low level driver about addition of an associated station,
34e895075e Johannes Berg          2010-02-03  3323   *	AP, IBSS/WDS/mesh peer etc. This callback can sleep.
34e895075e Johannes Berg          2010-02-03  3324   *
34e895075e Johannes Berg          2010-02-03  3325   * @sta_remove: Notifies low level driver about removal of an associated
6a9d1b91f3 Johannes Berg          2013-12-04  3326   *	station, AP, IBSS/WDS/mesh peer etc. Note that after the callback
6a9d1b91f3 Johannes Berg          2013-12-04  3327   *	returns it isn't safe to use the pointer, not even RCU protected;
6a9d1b91f3 Johannes Berg          2013-12-04  3328   *	no RCU grace period is guaranteed between returning here and freeing
6a9d1b91f3 Johannes Berg          2013-12-04  3329   *	the station. See @sta_pre_rcu_remove if needed.
6a9d1b91f3 Johannes Berg          2013-12-04  3330   *	This callback can sleep.
34e895075e Johannes Berg          2010-02-03  3331   *
77d2ece6fd Sujith Manoharan       2012-11-20  3332   * @sta_add_debugfs: Drivers can use this callback to add debugfs files
77d2ece6fd Sujith Manoharan       2012-11-20  3333   *	when a station is added to mac80211's station list. This callback
c7e9dbcf09 Johannes Berg          2016-09-14  3334   *	should be within a CONFIG_MAC80211_DEBUGFS conditional. This
c7e9dbcf09 Johannes Berg          2016-09-14  3335   *	callback can sleep.
77d2ece6fd Sujith Manoharan       2012-11-20  3336   *
34e895075e Johannes Berg          2010-02-03  3337   * @sta_notify: Notifies low level driver about power state transition of an
d057e5a381 Arik Nemtsov           2011-01-31  3338   *	associated station, AP,  IBSS/WDS/mesh peer etc. For a VIF operating
d057e5a381 Arik Nemtsov           2011-01-31  3339   *	in AP mode, this callback will not be called when the flag
d057e5a381 Arik Nemtsov           2011-01-31  3340   *	%IEEE80211_HW_AP_LINK_PS is set. Must be atomic.
4571d3bf87 Christian Lamparter    2008-11-30  3341   *
f09603a259 Johannes Berg          2012-01-20  3342   * @sta_state: Notifies low level driver about state transition of a
f09603a259 Johannes Berg          2012-01-20  3343   *	station (which can be the AP, a client, IBSS/WDS/mesh peer etc.)
f09603a259 Johannes Berg          2012-01-20  3344   *	This callback is mutually exclusive with @sta_add/@sta_remove.
f09603a259 Johannes Berg          2012-01-20  3345   *	It must not fail for down transitions but may fail for transitions
6a9d1b91f3 Johannes Berg          2013-12-04  3346   *	up the list of states. Also note that after the callback returns it
6a9d1b91f3 Johannes Berg          2013-12-04  3347   *	isn't safe to use the pointer, not even RCU protected - no RCU grace
6a9d1b91f3 Johannes Berg          2013-12-04  3348   *	period is guaranteed between returning here and freeing the station.
6a9d1b91f3 Johannes Berg          2013-12-04  3349   *	See @sta_pre_rcu_remove if needed.
6a9d1b91f3 Johannes Berg          2013-12-04  3350   *	The callback can sleep.
6a9d1b91f3 Johannes Berg          2013-12-04  3351   *
6a9d1b91f3 Johannes Berg          2013-12-04  3352   * @sta_pre_rcu_remove: Notify driver about station removal before RCU
6a9d1b91f3 Johannes Berg          2013-12-04  3353   *	synchronisation. This is useful if a driver needs to have station
6a9d1b91f3 Johannes Berg          2013-12-04  3354   *	pointers protected using RCU, it can then use this call to clear
6a9d1b91f3 Johannes Berg          2013-12-04  3355   *	the pointers instead of waiting for an RCU grace period to elapse
6a9d1b91f3 Johannes Berg          2013-12-04  3356   *	in @sta_state.
f09603a259 Johannes Berg          2012-01-20  3357   *	The callback can sleep.
f09603a259 Johannes Berg          2012-01-20  3358   *
8f727ef3c4 Johannes Berg          2012-03-30  3359   * @sta_rc_update: Notifies the driver of changes to the bitrates that can be
8f727ef3c4 Johannes Berg          2012-03-30  3360   *	used to transmit to the station. The changes are advertised with bits
8f727ef3c4 Johannes Berg          2012-03-30  3361   *	from &enum ieee80211_rate_control_changed and the values are reflected
8f727ef3c4 Johannes Berg          2012-03-30  3362   *	in the station data. This callback should only be used when the driver
8f727ef3c4 Johannes Berg          2012-03-30  3363   *	uses hardware rate control (%IEEE80211_HW_HAS_RATE_CONTROL) since
8f727ef3c4 Johannes Berg          2012-03-30  3364   *	otherwise the rate control algorithm is notified directly.
8f727ef3c4 Johannes Berg          2012-03-30  3365   *	Must be atomic.
f815e2b3c0 Johannes Berg          2014-11-19  3366   * @sta_rate_tbl_update: Notifies the driver that the rate table changed. This
f815e2b3c0 Johannes Berg          2014-11-19  3367   *	is only used if the configured rate control algorithm actually uses
f815e2b3c0 Johannes Berg          2014-11-19  3368   *	the new rate table API, and is therefore optional. Must be atomic.
8f727ef3c4 Johannes Berg          2012-03-30  3369   *
2b9a7e1bac Johannes Berg          2014-11-17  3370   * @sta_statistics: Get statistics for this station. For example with beacon
2b9a7e1bac Johannes Berg          2014-11-17  3371   *	filtering, the statistics kept by mac80211 might not be accurate, so
2b9a7e1bac Johannes Berg          2014-11-17  3372   *	let the driver pre-fill the statistics. The driver can fill most of
2b9a7e1bac Johannes Berg          2014-11-17  3373   *	the values (indicating which by setting the filled bitmap), but not
2b9a7e1bac Johannes Berg          2014-11-17  3374   *	all of them make sense - see the source for which ones are possible.
2b9a7e1bac Johannes Berg          2014-11-17  3375   *	Statistics that the driver doesn't fill will be filled by mac80211.
2b9a7e1bac Johannes Berg          2014-11-17  3376   *	The callback can sleep.
2b9a7e1bac Johannes Berg          2014-11-17  3377   *
75a5f0ccfd Johannes Berg          2007-09-18  3378   * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
fe3fa82731 Johannes Berg          2008-09-08  3379   *	bursting) for a hardware TX queue.
6dd1bf3118 Bob Copeland           2009-01-08  3380   *	Returns a negative error code on failure.
e1781ed33a Kalle Valo             2009-12-23  3381   *	The callback can sleep.
75a5f0ccfd Johannes Berg          2007-09-18  3382   *
75a5f0ccfd Johannes Berg          2007-09-18  3383   * @get_tsf: Get the current TSF timer value from firmware/hardware. Currently,
3b5d665b51 Alina Friedrichsen     2009-01-24  3384   *	this is only used for IBSS mode BSSID merging and debugging. Is not a
7b08b3b4a9 Alina Friedrichsen     2009-02-05  3385   *	required function.
e1781ed33a Kalle Valo             2009-12-23  3386   *	The callback can sleep.
3b5d665b51 Alina Friedrichsen     2009-01-24  3387   *
3b5d665b51 Alina Friedrichsen     2009-01-24  3388   * @set_tsf: Set the TSF timer to the specified value in the firmware/hardware.
3b5d665b51 Alina Friedrichsen     2009-01-24  3389   *	Currently, this is only used for IBSS mode debugging. Is not a
7b08b3b4a9 Alina Friedrichsen     2009-02-05  3390   *	required function.
e1781ed33a Kalle Valo             2009-12-23  3391   *	The callback can sleep.
75a5f0ccfd Johannes Berg          2007-09-18  3392   *
354d381baf Pedersen, Thomas       2016-09-28  3393   * @offset_tsf: Offset the TSF timer by the specified value in the
354d381baf Pedersen, Thomas       2016-09-28  3394   *	firmware/hardware.  Preferred to set_tsf as it avoids delay between
354d381baf Pedersen, Thomas       2016-09-28  3395   *	calling set_tsf() and hardware getting programmed, which will show up
354d381baf Pedersen, Thomas       2016-09-28  3396   *	as TSF delay. Is not a required function.
354d381baf Pedersen, Thomas       2016-09-28  3397   *	The callback can sleep.
354d381baf Pedersen, Thomas       2016-09-28  3398   *
75a5f0ccfd Johannes Berg          2007-09-18  3399   * @reset_tsf: Reset the TSF timer and allow firmware/hardware to synchronize
75a5f0ccfd Johannes Berg          2007-09-18  3400   *	with other STAs in the IBSS. This is only used in IBSS mode. This
75a5f0ccfd Johannes Berg          2007-09-18  3401   *	function is optional if the firmware/hardware takes full care of
75a5f0ccfd Johannes Berg          2007-09-18  3402   *	TSF synchronization.
e1781ed33a Kalle Valo             2009-12-23  3403   *	The callback can sleep.
75a5f0ccfd Johannes Berg          2007-09-18  3404   *
75a5f0ccfd Johannes Berg          2007-09-18  3405   * @tx_last_beacon: Determine whether the last IBSS beacon was sent by us.
75a5f0ccfd Johannes Berg          2007-09-18  3406   *	This is needed only for IBSS mode and the result of this function is
75a5f0ccfd Johannes Berg          2007-09-18  3407   *	used to determine whether to reply to Probe Requests.
6dd1bf3118 Bob Copeland           2009-01-08  3408   *	Returns non-zero if this device sent the last beacon.
e1781ed33a Kalle Valo             2009-12-23  3409   *	The callback can sleep.
d3c990fb26 Ron Rindjunsky         2007-11-26  3410   *
4e8998f09b Randy Dunlap           2010-05-21  3411   * @get_survey: Return per-channel survey information
4e8998f09b Randy Dunlap           2010-05-21  3412   *
1f87f7d3a3 Johannes Berg          2009-06-02  3413   * @rfkill_poll: Poll rfkill hardware state. If you need this, you also
1f87f7d3a3 Johannes Berg          2009-06-02  3414   *	need to set wiphy->rfkill_poll to %true before registration,
1f87f7d3a3 Johannes Berg          2009-06-02  3415   *	and need to call wiphy_rfkill_set_hw_state() in the callback.
e1781ed33a Kalle Valo             2009-12-23  3416   *	The callback can sleep.
aff89a9b90 Johannes Berg          2009-07-01  3417   *
310bc676e3 Lukáš Turek            2009-12-21  3418   * @set_coverage_class: Set slot time for given coverage class as specified
310bc676e3 Lukáš Turek            2009-12-21  3419   *	in IEEE 802.11-2007 section 17.3.8.6 and modify ACK timeout
a4bcaf5556 Lorenzo Bianconi       2014-09-04  3420   *	accordingly; coverage class equals to -1 to enable ACK timeout
a4bcaf5556 Lorenzo Bianconi       2014-09-04  3421   *	estimation algorithm (dynack). To disable dynack set valid value for
a4bcaf5556 Lorenzo Bianconi       2014-09-04  3422   *	coverage class. This callback is not required and may sleep.
310bc676e3 Lukáš Turek            2009-12-21  3423   *
52981cd794 David Spinadel         2013-07-31  3424   * @testmode_cmd: Implement a cfg80211 test mode command. The passed @vif may
52981cd794 David Spinadel         2013-07-31  3425   *	be %NULL. The callback can sleep.
71063f0e89 Wey-Yi Guy             2011-05-20  3426   * @testmode_dump: Implement a cfg80211 test mode dump. The callback can sleep.
a80f7c0b08 Johannes Berg          2009-12-23  3427   *
a80f7c0b08 Johannes Berg          2009-12-23  3428   * @flush: Flush all pending frames from the hardware queue, making sure
39ecc01d1b Johannes Berg          2013-02-13  3429   *	that the hardware queues are empty. The @queues parameter is a bitmap
39ecc01d1b Johannes Berg          2013-02-13  3430   *	of queues to flush, which is useful if different virtual interfaces
39ecc01d1b Johannes Berg          2013-02-13  3431   *	use different hardware queues; it may also indicate all queues.
39ecc01d1b Johannes Berg          2013-02-13  3432   *	If the parameter @drop is set to %true, pending frames may be dropped.
77be2c54c5 Emmanuel Grumbach      2014-03-27  3433   *	Note that vif can be NULL.
39ecc01d1b Johannes Berg          2013-02-13  3434   *	The callback can sleep.
5ce6e438d5 Johannes Berg          2010-05-11  3435   *
5ce6e438d5 Johannes Berg          2010-05-11  3436   * @channel_switch: Drivers that need (or want) to offload the channel
5ce6e438d5 Johannes Berg          2010-05-11  3437   *	switch operation for CSAs received from the AP may implement this
5ce6e438d5 Johannes Berg          2010-05-11  3438   *	callback. They must then call ieee80211_chswitch_done() to indicate
5ce6e438d5 Johannes Berg          2010-05-11  3439   *	completion of the channel switch.
4e6cbfd09c John W. Linville       2010-07-29  3440   *
79b1c460a0 Bruno Randolf          2010-11-24  3441   * @set_antenna: Set antenna configuration (tx_ant, rx_ant) on the device.
79b1c460a0 Bruno Randolf          2010-11-24  3442   *	Parameters are bitmaps of allowed antennas to use for TX/RX. Drivers may
79b1c460a0 Bruno Randolf          2010-11-24  3443   *	reject TX/RX mask combinations they cannot support by returning -EINVAL
79b1c460a0 Bruno Randolf          2010-11-24  3444   *	(also see nl80211.h @NL80211_ATTR_WIPHY_ANTENNA_TX).
79b1c460a0 Bruno Randolf          2010-11-24  3445   *
79b1c460a0 Bruno Randolf          2010-11-24  3446   * @get_antenna: Get current antenna configuration from device (tx_ant, rx_ant).
4976b4eb9d Johannes Berg          2011-01-04  3447   *
4976b4eb9d Johannes Berg          2011-01-04  3448   * @remain_on_channel: Starts an off-channel period on the given channel, must
4976b4eb9d Johannes Berg          2011-01-04  3449   *	call back to ieee80211_ready_on_channel() when on that channel. Note
4976b4eb9d Johannes Berg          2011-01-04  3450   *	that normal channel traffic is not stopped as this is intended for hw
4976b4eb9d Johannes Berg          2011-01-04  3451   *	offload. Frames to transmit on the off-channel channel are transmitted
4976b4eb9d Johannes Berg          2011-01-04  3452   *	normally except for the %IEEE80211_TX_CTL_TX_OFFCHAN flag. When the
4976b4eb9d Johannes Berg          2011-01-04  3453   *	duration (which will always be non-zero) expires, the driver must call
196ac1c13d Johannes Berg          2012-06-05  3454   *	ieee80211_remain_on_channel_expired().
196ac1c13d Johannes Berg          2012-06-05  3455   *	Note that this callback may be called while the device is in IDLE and
196ac1c13d Johannes Berg          2012-06-05  3456   *	must be accepted in this case.
196ac1c13d Johannes Berg          2012-06-05  3457   *	This callback may sleep.
4976b4eb9d Johannes Berg          2011-01-04  3458   * @cancel_remain_on_channel: Requests that an ongoing off-channel period is
4976b4eb9d Johannes Berg          2011-01-04  3459   *	aborted before it expires. This callback may sleep.
38c091590f John W. Linville       2011-03-07  3460   *
38c091590f John W. Linville       2011-03-07  3461   * @set_ringparam: Set tx and rx ring sizes.
38c091590f John W. Linville       2011-03-07  3462   *
38c091590f John W. Linville       2011-03-07  3463   * @get_ringparam: Get tx and rx ring current and maximum sizes.
e8306f9894 Vivek Natarajan        2011-04-06  3464   *
e8306f9894 Vivek Natarajan        2011-04-06  3465   * @tx_frames_pending: Check if there is any pending frame in the hardware
e8306f9894 Vivek Natarajan        2011-04-06  3466   *	queues before entering power save.
bdbfd6b582 Sujith Manoharan       2011-04-27  3467   *
bdbfd6b582 Sujith Manoharan       2011-04-27  3468   * @set_bitrate_mask: Set a mask of rates to be used for rate control selection
bdbfd6b582 Sujith Manoharan       2011-04-27  3469   *	when transmitting a frame. Currently only legacy rates are handled.
bdbfd6b582 Sujith Manoharan       2011-04-27  3470   *	The callback can sleep.
a818292952 Emmanuel Grumbach      2015-03-16  3471   * @event_callback: Notify driver about any event in mac80211. See
a818292952 Emmanuel Grumbach      2015-03-16  3472   *	&enum ieee80211_event_type for the different types.
6382246e89 Emmanuel Grumbach      2015-04-20  3473   *	The callback must be atomic.
4049e09acd Johannes Berg          2011-09-29  3474   *
4049e09acd Johannes Berg          2011-09-29  3475   * @release_buffered_frames: Release buffered frames according to the given
4049e09acd Johannes Berg          2011-09-29  3476   *	parameters. In the case where the driver buffers some frames for
4049e09acd Johannes Berg          2011-09-29  3477   *	sleeping stations mac80211 will use this callback to tell the driver
4049e09acd Johannes Berg          2011-09-29  3478   *	to release some frames, either for PS-poll or uAPSD.
e227867f12 Masanari Iida          2014-02-18  3479   *	Note that if the @more_data parameter is %false the driver must check
4049e09acd Johannes Berg          2011-09-29  3480   *	if there are more frames on the given TIDs, and if there are more than
4049e09acd Johannes Berg          2011-09-29  3481   *	the frames being released then it must still set the more-data bit in
4049e09acd Johannes Berg          2011-09-29  3482   *	the frame. If the @more_data parameter is %true, then of course the
4049e09acd Johannes Berg          2011-09-29  3483   *	more-data bit must always be set.
4049e09acd Johannes Berg          2011-09-29  3484   *	The @tids parameter tells the driver which TIDs to release frames
4049e09acd Johannes Berg          2011-09-29  3485   *	from, for PS-poll it will always have only a single bit set.
deeaee197b Johannes Berg          2011-09-29  3486   *	In the case this is used for a PS-poll initiated release, the
deeaee197b Johannes Berg          2011-09-29  3487   *	@num_frames parameter will always be 1 so code can be shared. In
deeaee197b Johannes Berg          2011-09-29  3488   *	this case the driver must also set %IEEE80211_TX_STATUS_EOSP flag
deeaee197b Johannes Berg          2011-09-29  3489   *	on the TX status (and must report TX status) so that the PS-poll
deeaee197b Johannes Berg          2011-09-29  3490   *	period is properly ended. This is used to avoid sending multiple
deeaee197b Johannes Berg          2011-09-29  3491   *	responses for a retried PS-poll frame.
4049e09acd Johannes Berg          2011-09-29  3492   *	In the case this is used for uAPSD, the @num_frames parameter may be
4049e09acd Johannes Berg          2011-09-29  3493   *	bigger than one, but the driver may send fewer frames (it must send
4049e09acd Johannes Berg          2011-09-29  3494   *	at least one, however). In this case it is also responsible for
47086fc51a Johannes Berg          2011-09-29  3495   *	setting the EOSP flag in the QoS header of the frames. Also, when the
47086fc51a Johannes Berg          2011-09-29  3496   *	service period ends, the driver must set %IEEE80211_TX_STATUS_EOSP
37fbd90800 Johannes Berg          2011-09-29  3497   *	on the last frame in the SP. Alternatively, it may call the function
e943789edb Johannes Berg          2013-02-15  3498   *	ieee80211_sta_eosp() to inform mac80211 of the end of the SP.
4049e09acd Johannes Berg          2011-09-29  3499   *	This callback must be atomic.
40b9640883 Johannes Berg          2011-09-29  3500   * @allow_buffered_frames: Prepare device to allow the given number of frames
40b9640883 Johannes Berg          2011-09-29  3501   *	to go out to the given station. The frames will be sent by mac80211
40b9640883 Johannes Berg          2011-09-29  3502   *	via the usual TX path after this call. The TX information for frames
02f2f1a951 Johannes Berg          2012-02-27  3503   *	released will also have the %IEEE80211_TX_CTL_NO_PS_BUFFER flag set
40b9640883 Johannes Berg          2011-09-29  3504   *	and the last one will also have %IEEE80211_TX_STATUS_EOSP set. In case
40b9640883 Johannes Berg          2011-09-29  3505   *	frames from multiple TIDs are released and the driver might reorder
40b9640883 Johannes Berg          2011-09-29  3506   *	them between the TIDs, it must set the %IEEE80211_TX_STATUS_EOSP flag
40b9640883 Johannes Berg          2011-09-29  3507   *	on the last frame and clear it on all others and also handle the EOSP
37fbd90800 Johannes Berg          2011-09-29  3508   *	bit in the QoS header correctly. Alternatively, it can also call the
e943789edb Johannes Berg          2013-02-15  3509   *	ieee80211_sta_eosp() function.
40b9640883 Johannes Berg          2011-09-29  3510   *	The @tids parameter is a bitmap and tells the driver which TIDs the
40b9640883 Johannes Berg          2011-09-29  3511   *	frames will be on; it will at most have two bits set.
40b9640883 Johannes Berg          2011-09-29  3512   *	This callback must be atomic.
e352114fd6 Ben Greear             2012-04-23  3513   *
e352114fd6 Ben Greear             2012-04-23  3514   * @get_et_sset_count:  Ethtool API to get string-set count.
e352114fd6 Ben Greear             2012-04-23  3515   *
e352114fd6 Ben Greear             2012-04-23  3516   * @get_et_stats:  Ethtool API to get a set of u64 stats.
e352114fd6 Ben Greear             2012-04-23  3517   *
e352114fd6 Ben Greear             2012-04-23  3518   * @get_et_strings:  Ethtool API to get a set of strings to describe stats
e352114fd6 Ben Greear             2012-04-23  3519   *	and perhaps other supported types of ethtool data-sets.
e352114fd6 Ben Greear             2012-04-23  3520   *
a1845fc7c5 Johannes Berg          2012-06-27  3521   * @mgd_prepare_tx: Prepare for transmitting a management frame for association
a1845fc7c5 Johannes Berg          2012-06-27  3522   *	before associated. In multi-channel scenarios, a virtual interface is
a1845fc7c5 Johannes Berg          2012-06-27  3523   *	bound to a channel before it is associated, but as it isn't associated
a1845fc7c5 Johannes Berg          2012-06-27  3524   *	yet it need not necessarily be given airtime, in particular since any
a1845fc7c5 Johannes Berg          2012-06-27  3525   *	transmission to a P2P GO needs to be synchronized against the GO's
a1845fc7c5 Johannes Berg          2012-06-27  3526   *	powersave state. mac80211 will call this function before transmitting a
a1845fc7c5 Johannes Berg          2012-06-27  3527   *	management frame prior to having successfully associated to allow the
a1845fc7c5 Johannes Berg          2012-06-27  3528   *	driver to give it channel time for the transmission, to get a response
a1845fc7c5 Johannes Berg          2012-06-27  3529   *	and to be able to synchronize with the GO.
94ba92713f Ilan Peer              2018-02-19  3530   *	For drivers that set %IEEE80211_HW_DEAUTH_NEED_MGD_TX_PREP, mac80211
94ba92713f Ilan Peer              2018-02-19  3531   *	would also call this function before transmitting a deauthentication
94ba92713f Ilan Peer              2018-02-19  3532   *	frame in case that no beacon was heard from the AP/P2P GO.
a1845fc7c5 Johannes Berg          2012-06-27  3533   *	The callback will be called before each transmission and upon return
a1845fc7c5 Johannes Berg          2012-06-27  3534   *	mac80211 will transmit the frame right away.
d4e36e5554 Ilan Peer              2018-04-20  3535   *      If duration is greater than zero, mac80211 hints to the driver the
d4e36e5554 Ilan Peer              2018-04-20  3536   *      duration for which the operation is requested.
a1845fc7c5 Johannes Berg          2012-06-27  3537   *	The callback is optional and can (should!) sleep.
c3645eac47 Michal Kazior          2012-06-26  3538   *
ee10f2c779 Arik Nemtsov           2014-06-11  3539   * @mgd_protect_tdls_discover: Protect a TDLS discovery session. After sending
ee10f2c779 Arik Nemtsov           2014-06-11  3540   *	a TDLS discovery-request, we expect a reply to arrive on the AP's
ee10f2c779 Arik Nemtsov           2014-06-11  3541   *	channel. We must stay on the channel (no PSM, scan, etc.), since a TDLS
ee10f2c779 Arik Nemtsov           2014-06-11  3542   *	setup-response is a direct packet not buffered by the AP.
ee10f2c779 Arik Nemtsov           2014-06-11  3543   *	mac80211 will call this function just before the transmission of a TDLS
ee10f2c779 Arik Nemtsov           2014-06-11  3544   *	discovery-request. The recommended period of protection is at least
ee10f2c779 Arik Nemtsov           2014-06-11  3545   *	2 * (DTIM period).
ee10f2c779 Arik Nemtsov           2014-06-11  3546   *	The callback is optional and can sleep.
ee10f2c779 Arik Nemtsov           2014-06-11  3547   *
c3645eac47 Michal Kazior          2012-06-26  3548   * @add_chanctx: Notifies device driver about new channel context creation.
dcae9e0203 Chaitanya T K          2015-10-30  3549   *	This callback may sleep.
c3645eac47 Michal Kazior          2012-06-26  3550   * @remove_chanctx: Notifies device driver about channel context destruction.
dcae9e0203 Chaitanya T K          2015-10-30  3551   *	This callback may sleep.
c3645eac47 Michal Kazior          2012-06-26  3552   * @change_chanctx: Notifies device driver about channel context changes that
c3645eac47 Michal Kazior          2012-06-26  3553   *	may happen when combining different virtual interfaces on the same
c3645eac47 Michal Kazior          2012-06-26  3554   *	channel context with different settings
dcae9e0203 Chaitanya T K          2015-10-30  3555   *	This callback may sleep.
c3645eac47 Michal Kazior          2012-06-26  3556   * @assign_vif_chanctx: Notifies device driver about channel context being bound
c3645eac47 Michal Kazior          2012-06-26  3557   *	to vif. Possible use is for hw queue remapping.
dcae9e0203 Chaitanya T K          2015-10-30  3558   *	This callback may sleep.
c3645eac47 Michal Kazior          2012-06-26  3559   * @unassign_vif_chanctx: Notifies device driver about channel context being
c3645eac47 Michal Kazior          2012-06-26  3560   *	unbound from vif.
dcae9e0203 Chaitanya T K          2015-10-30  3561   *	This callback may sleep.
1a5f0c13d1 Luciano Coelho         2014-05-23  3562   * @switch_vif_chanctx: switch a number of vifs from one chanctx to
1a5f0c13d1 Luciano Coelho         2014-05-23  3563   *	another, as specified in the list of
1a5f0c13d1 Luciano Coelho         2014-05-23  3564   *	@ieee80211_vif_chanctx_switch passed to the driver, according
1a5f0c13d1 Luciano Coelho         2014-05-23  3565   *	to the mode defined in &ieee80211_chanctx_switch_mode.
dcae9e0203 Chaitanya T K          2015-10-30  3566   *	This callback may sleep.
1a5f0c13d1 Luciano Coelho         2014-05-23  3567   *
1041638f2b Johannes Berg          2012-10-19  3568   * @start_ap: Start operation on the AP interface, this is called after all the
1041638f2b Johannes Berg          2012-10-19  3569   *	information in bss_conf is set and beacon can be retrieved. A channel
1041638f2b Johannes Berg          2012-10-19  3570   *	context is bound before this is called. Note that if the driver uses
1041638f2b Johannes Berg          2012-10-19  3571   *	software scan or ROC, this (and @stop_ap) isn't called when the AP is
1041638f2b Johannes Berg          2012-10-19  3572   *	just "paused" for scanning/ROC, which is indicated by the beacon being
1041638f2b Johannes Berg          2012-10-19  3573   *	disabled/enabled via @bss_info_changed.
1041638f2b Johannes Berg          2012-10-19  3574   * @stop_ap: Stop operation on the AP interface.
9214ad7f9a Johannes Berg          2012-11-06  3575   *
cf2c92d840 Eliad Peller           2014-11-04  3576   * @reconfig_complete: Called after a call to ieee80211_restart_hw() and
cf2c92d840 Eliad Peller           2014-11-04  3577   *	during resume, when the reconfiguration has completed.
cf2c92d840 Eliad Peller           2014-11-04  3578   *	This can help the driver implement the reconfiguration step (and
cf2c92d840 Eliad Peller           2014-11-04  3579   *	indicate mac80211 is ready to receive frames).
cf2c92d840 Eliad Peller           2014-11-04  3580   *	This callback may sleep.
8f21b0adfe Johannes Berg          2013-01-11  3581   *
a65240c101 Johannes Berg          2013-01-14  3582   * @ipv6_addr_change: IPv6 address assignment on the given interface changed.
a65240c101 Johannes Berg          2013-01-14  3583   *	Currently, this is only called for managed or P2P client interfaces.
a65240c101 Johannes Berg          2013-01-14  3584   *	This callback is optional; it must not sleep.
73da7d5bab Simon Wunderlich       2013-07-11  3585   *
73da7d5bab Simon Wunderlich       2013-07-11  3586   * @channel_switch_beacon: Starts a channel switch to a new channel.
73da7d5bab Simon Wunderlich       2013-07-11  3587   *	Beacons are modified to include CSA or ECSA IEs before calling this
73da7d5bab Simon Wunderlich       2013-07-11  3588   *	function. The corresponding count fields in these IEs must be
66e01cf99e Luciano Coelho         2014-01-13  3589   *	decremented, and when they reach 1 the driver must call
73da7d5bab Simon Wunderlich       2013-07-11  3590   *	ieee80211_csa_finish(). Drivers which use ieee80211_beacon_get()
73da7d5bab Simon Wunderlich       2013-07-11  3591   *	get the csa counter decremented by mac80211, but must check if it is
66e01cf99e Luciano Coelho         2014-01-13  3592   *	1 using ieee80211_csa_is_complete() after the beacon has been
73da7d5bab Simon Wunderlich       2013-07-11  3593   *	transmitted and then call ieee80211_csa_finish().
66e01cf99e Luciano Coelho         2014-01-13  3594   *	If the CSA count starts as zero or 1, this function will not be called,
66e01cf99e Luciano Coelho         2014-01-13  3595   *	since there won't be any time to beacon before the switch anyway.
6d027bcc8a Luciano Coelho         2014-10-08  3596   * @pre_channel_switch: This is an optional callback that is called
6d027bcc8a Luciano Coelho         2014-10-08  3597   *	before a channel switch procedure is started (ie. when a STA
9332ef9dbd Masahiro Yamada        2017-02-27  3598   *	gets a CSA or a userspace initiated channel-switch), allowing
6d027bcc8a Luciano Coelho         2014-10-08  3599   *	the driver to prepare for the channel switch.
f1d65583bc Luciano Coelho         2014-10-08  3600   * @post_channel_switch: This is an optional callback that is called
f1d65583bc Luciano Coelho         2014-10-08  3601   *	after a channel switch procedure is completed, allowing the
f1d65583bc Luciano Coelho         2014-10-08  3602   *	driver to go back to a normal configuration.
73da7d5bab Simon Wunderlich       2013-07-11  3603   *
55fff50113 Johannes Berg          2013-08-19  3604   * @join_ibss: Join an IBSS (on an IBSS interface); this is called after all
55fff50113 Johannes Berg          2013-08-19  3605   *	information in bss_conf is set up and the beacon can be retrieved. A
55fff50113 Johannes Berg          2013-08-19  3606   *	channel context is bound before this is called.
55fff50113 Johannes Berg          2013-08-19  3607   * @leave_ibss: Leave the IBSS again.
cca674d47e Antonio Quartulli      2014-05-19  3608   *
cca674d47e Antonio Quartulli      2014-05-19  3609   * @get_expected_throughput: extract the expected throughput towards the
cca674d47e Antonio Quartulli      2014-05-19  3610   *	specified station. The returned value is expressed in Kbps. It returns 0
cca674d47e Antonio Quartulli      2014-05-19  3611   *	if the RC algorithm does not have proper data to provide.
5b3dc42b1b Felix Fietkau          2014-10-26  3612   *
5b3dc42b1b Felix Fietkau          2014-10-26  3613   * @get_txpower: get current maximum tx power (in dBm) based on configuration
5b3dc42b1b Felix Fietkau          2014-10-26  3614   *	and hardware limits.
a7a6bdd067 Arik Nemtsov           2014-11-09  3615   *
a7a6bdd067 Arik Nemtsov           2014-11-09  3616   * @tdls_channel_switch: Start channel-switching with a TDLS peer. The driver
a7a6bdd067 Arik Nemtsov           2014-11-09  3617   *	is responsible for continually initiating channel-switching operations
a7a6bdd067 Arik Nemtsov           2014-11-09  3618   *	and returning to the base channel for communication with the AP. The
a7a6bdd067 Arik Nemtsov           2014-11-09  3619   *	driver receives a channel-switch request template and the location of
a7a6bdd067 Arik Nemtsov           2014-11-09  3620   *	the switch-timing IE within the template as part of the invocation.
a7a6bdd067 Arik Nemtsov           2014-11-09  3621   *	The template is valid only within the call, and the driver can
a7a6bdd067 Arik Nemtsov           2014-11-09  3622   *	optionally copy the skb for further re-use.
a7a6bdd067 Arik Nemtsov           2014-11-09  3623   * @tdls_cancel_channel_switch: Stop channel-switching with a TDLS peer. Both
a7a6bdd067 Arik Nemtsov           2014-11-09  3624   *	peers must be on the base channel when the call completes.
8a4d32f30d Arik Nemtsov           2014-11-09  3625   * @tdls_recv_channel_switch: a TDLS channel-switch related frame (request or
8a4d32f30d Arik Nemtsov           2014-11-09  3626   *	response) has been received from a remote peer. The driver gets
8a4d32f30d Arik Nemtsov           2014-11-09  3627   *	parameters parsed from the incoming frame and may use them to continue
8a4d32f30d Arik Nemtsov           2014-11-09  3628   *	an ongoing channel-switch operation. In addition, a channel-switch
8a4d32f30d Arik Nemtsov           2014-11-09  3629   *	response template is provided, together with the location of the
8a4d32f30d Arik Nemtsov           2014-11-09  3630   *	switch-timing IE within the template. The skb can only be used within
8a4d32f30d Arik Nemtsov           2014-11-09  3631   *	the function call.
ba8c3d6f16 Felix Fietkau          2015-03-27  3632   *
ba8c3d6f16 Felix Fietkau          2015-03-27  3633   * @wake_tx_queue: Called when new packets have been added to the queue.
f59374eb42 Sara Sharon            2016-03-02  3634   * @sync_rx_queues: Process all pending frames in RSS queues. This is a
f59374eb42 Sara Sharon            2016-03-02  3635   *	synchronization which is needed in case driver has in its RSS queues
f59374eb42 Sara Sharon            2016-03-02  3636   *	pending frames that were received prior to the control path action
f59374eb42 Sara Sharon            2016-03-02  3637   *	currently taken (e.g. disassociation) but are not processed yet.
708d50edb1 Ayala Beker            2016-09-20  3638   *
708d50edb1 Ayala Beker            2016-09-20  3639   * @start_nan: join an existing NAN cluster, or create a new one.
708d50edb1 Ayala Beker            2016-09-20  3640   * @stop_nan: leave the NAN cluster.
5953ff6d6a Ayala Beker            2016-09-20  3641   * @nan_change_conf: change NAN configuration. The data in cfg80211_nan_conf
5953ff6d6a Ayala Beker            2016-09-20  3642   *	contains full new configuration and changes specify which parameters
5953ff6d6a Ayala Beker            2016-09-20  3643   *	are changed with respect to the last NAN config.
5953ff6d6a Ayala Beker            2016-09-20  3644   *	The driver gets both full configuration and the changed parameters since
5953ff6d6a Ayala Beker            2016-09-20  3645   *	some devices may need the full configuration while others need only the
5953ff6d6a Ayala Beker            2016-09-20  3646   *	changed parameters.
167e33f4f6 Ayala Beker            2016-09-20  3647   * @add_nan_func: Add a NAN function. Returns 0 on success. The data in
167e33f4f6 Ayala Beker            2016-09-20  3648   *	cfg80211_nan_func must not be referenced outside the scope of
167e33f4f6 Ayala Beker            2016-09-20  3649   *	this call.
167e33f4f6 Ayala Beker            2016-09-20  3650   * @del_nan_func: Remove a NAN function. The driver must call
167e33f4f6 Ayala Beker            2016-09-20  3651   *	ieee80211_nan_func_terminated() with
167e33f4f6 Ayala Beker            2016-09-20  3652   *	NL80211_NAN_FUNC_TERM_REASON_USER_REQUEST reason code upon removal.
9739fe29a2 Sara Sharon            2018-09-05  3653   * @can_aggregate_in_amsdu: Called in order to determine if HW supports
9739fe29a2 Sara Sharon            2018-09-05  3654   *	aggregating two specific frames in the same A-MSDU. The relation
9739fe29a2 Sara Sharon            2018-09-05  3655   *	between the skbs should be symmetric and transitive. Note that while
9739fe29a2 Sara Sharon            2018-09-05  3656   *	skb is always a real frame, head may or may not be an A-MSDU.
bc847970f4 Pradeep Kumar Chitrapu 2018-10-03  3657   * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
bc847970f4 Pradeep Kumar Chitrapu 2018-10-03  3658   *	Statistics should be cumulative, currently no way to reset is provided.
cee7013be9 Johannes Berg          2018-10-16  3659   *
cee7013be9 Johannes Berg          2018-10-16  3660   * @start_pmsr: start peer measurement (e.g. FTM) (this call can sleep)
cee7013be9 Johannes Berg          2018-10-16  3661   * @abort_pmsr: abort peer measurement (this call can sleep)
8f20fc2498 Johannes Berg          2007-08-28  3662   */
75a5f0ccfd Johannes Berg          2007-09-18  3663  struct ieee80211_ops {
36323f817a Thomas Huehn           2012-07-23  3664  	void (*tx)(struct ieee80211_hw *hw,
36323f817a Thomas Huehn           2012-07-23  3665  		   struct ieee80211_tx_control *control,
36323f817a Thomas Huehn           2012-07-23  3666  		   struct sk_buff *skb);
75a5f0ccfd Johannes Berg          2007-09-18  3667  	int (*start)(struct ieee80211_hw *hw);
75a5f0ccfd Johannes Berg          2007-09-18  3668  	void (*stop)(struct ieee80211_hw *hw);
eecc48000a Johannes Berg          2011-05-04  3669  #ifdef CONFIG_PM
eecc48000a Johannes Berg          2011-05-04  3670  	int (*suspend)(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan);
eecc48000a Johannes Berg          2011-05-04  3671  	int (*resume)(struct ieee80211_hw *hw);
6d52563f2b Johannes Berg          2012-04-04  3672  	void (*set_wakeup)(struct ieee80211_hw *hw, bool enabled);
eecc48000a Johannes Berg          2011-05-04  3673  #endif
75a5f0ccfd Johannes Berg          2007-09-18  3674  	int (*add_interface)(struct ieee80211_hw *hw,
1ed32e4fc8 Johannes Berg          2009-12-23  3675  			     struct ieee80211_vif *vif);
34d4bc4d41 Johannes Berg          2010-08-27  3676  	int (*change_interface)(struct ieee80211_hw *hw,
34d4bc4d41 Johannes Berg          2010-08-27  3677  				struct ieee80211_vif *vif,
2ca27bcff7 Johannes Berg          2010-09-16  3678  				enum nl80211_iftype new_type, bool p2p);
75a5f0ccfd Johannes Berg          2007-09-18  3679  	void (*remove_interface)(struct ieee80211_hw *hw,
1ed32e4fc8 Johannes Berg          2009-12-23  3680  				 struct ieee80211_vif *vif);
e8975581f6 Johannes Berg          2008-10-09  3681  	int (*config)(struct ieee80211_hw *hw, u32 changed);
471b3efdfc Johannes Berg          2007-12-28  3682  	void (*bss_info_changed)(struct ieee80211_hw *hw,
471b3efdfc Johannes Berg          2007-12-28  3683  				 struct ieee80211_vif *vif,
471b3efdfc Johannes Berg          2007-12-28  3684  				 struct ieee80211_bss_conf *info,
471b3efdfc Johannes Berg          2007-12-28  3685  				 u32 changed);
b2abb6e2bc Johannes Berg          2011-07-19  3686  
1041638f2b Johannes Berg          2012-10-19  3687  	int (*start_ap)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
1041638f2b Johannes Berg          2012-10-19  3688  	void (*stop_ap)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
1041638f2b Johannes Berg          2012-10-19  3689  
3ac64beecd Johannes Berg          2009-08-17  3690  	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
22bedad3ce Jiri Pirko             2010-04-01  3691  				 struct netdev_hw_addr_list *mc_list);
75a5f0ccfd Johannes Berg          2007-09-18  3692  	void (*configure_filter)(struct ieee80211_hw *hw,
75a5f0ccfd Johannes Berg          2007-09-18  3693  				 unsigned int changed_flags,
75a5f0ccfd Johannes Berg          2007-09-18  3694  				 unsigned int *total_flags,
3ac64beecd Johannes Berg          2009-08-17  3695  				 u64 multicast);
1b09b5568e Andrei Otcheretianski  2015-08-15  3696  	void (*config_iface_filter)(struct ieee80211_hw *hw,
1b09b5568e Andrei Otcheretianski  2015-08-15  3697  				    struct ieee80211_vif *vif,
1b09b5568e Andrei Otcheretianski  2015-08-15  3698  				    unsigned int filter_flags,
1b09b5568e Andrei Otcheretianski  2015-08-15  3699  				    unsigned int changed_flags);
17741cdc26 Johannes Berg          2008-09-11  3700  	int (*set_tim)(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
17741cdc26 Johannes Berg          2008-09-11  3701  		       bool set);
ea49c359f3 Johannes Berg          2007-09-18  3702  	int (*set_key)(struct ieee80211_hw *hw, enum set_key_cmd cmd,
dc822b5db4 Johannes Berg          2008-12-29  3703  		       struct ieee80211_vif *vif, struct ieee80211_sta *sta,
11a843b7e1 Johannes Berg          2007-08-28  3704  		       struct ieee80211_key_conf *key);
9ae4fda332 Emmanuel Grumbach      2008-03-20  3705  	void (*update_tkip_key)(struct ieee80211_hw *hw,
b3fbdcf49f Johannes Berg          2010-01-21  3706  				struct ieee80211_vif *vif,
b3fbdcf49f Johannes Berg          2010-01-21  3707  				struct ieee80211_key_conf *conf,
b3fbdcf49f Johannes Berg          2010-01-21  3708  				struct ieee80211_sta *sta,
9ae4fda332 Emmanuel Grumbach      2008-03-20  3709  				u32 iv32, u16 *phase1key);
c68f4b892c Johannes Berg          2011-07-05  3710  	void (*set_rekey_data)(struct ieee80211_hw *hw,
c68f4b892c Johannes Berg          2011-07-05  3711  			       struct ieee80211_vif *vif,
c68f4b892c Johannes Berg          2011-07-05  3712  			       struct cfg80211_gtk_rekey_data *data);
de5fad8157 Yoni Divinsky          2012-05-30  3713  	void (*set_default_unicast_key)(struct ieee80211_hw *hw,
de5fad8157 Yoni Divinsky          2012-05-30  3714  					struct ieee80211_vif *vif, int idx);
a060bbfe4e Johannes Berg          2010-04-27  3715  	int (*hw_scan)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
c56ef67250 David Spinadel         2014-02-05  3716  		       struct ieee80211_scan_request *req);
b856439b1b Eliad Peller           2011-06-13  3717  	void (*cancel_hw_scan)(struct ieee80211_hw *hw,
b856439b1b Eliad Peller           2011-06-13  3718  			       struct ieee80211_vif *vif);
79f460ca49 Luciano Coelho         2011-05-11  3719  	int (*sched_scan_start)(struct ieee80211_hw *hw,
79f460ca49 Luciano Coelho         2011-05-11  3720  				struct ieee80211_vif *vif,
79f460ca49 Luciano Coelho         2011-05-11  3721  				struct cfg80211_sched_scan_request *req,
633e271326 David Spinadel         2014-02-06  3722  				struct ieee80211_scan_ies *ies);
37e3308cb2 Johannes Berg          2014-02-17  3723  	int (*sched_scan_stop)(struct ieee80211_hw *hw,
79f460ca49 Luciano Coelho         2011-05-11  3724  			       struct ieee80211_vif *vif);
a344d6778a Johannes Berg          2014-06-12  3725  	void (*sw_scan_start)(struct ieee80211_hw *hw,
a344d6778a Johannes Berg          2014-06-12  3726  			      struct ieee80211_vif *vif,
a344d6778a Johannes Berg          2014-06-12  3727  			      const u8 *mac_addr);
a344d6778a Johannes Berg          2014-06-12  3728  	void (*sw_scan_complete)(struct ieee80211_hw *hw,
a344d6778a Johannes Berg          2014-06-12  3729  				 struct ieee80211_vif *vif);
f0706e828e Jiri Benc              2007-05-05  3730  	int (*get_stats)(struct ieee80211_hw *hw,
f0706e828e Jiri Benc              2007-05-05  3731  			 struct ieee80211_low_level_stats *stats);
9352c19f63 Johannes Berg          2015-04-20  3732  	void (*get_key_seq)(struct ieee80211_hw *hw,
9352c19f63 Johannes Berg          2015-04-20  3733  			    struct ieee80211_key_conf *key,
9352c19f63 Johannes Berg          2015-04-20  3734  			    struct ieee80211_key_seq *seq);
f23a478075 Arik Nemtsov           2010-11-08  3735  	int (*set_frag_threshold)(struct ieee80211_hw *hw, u32 value);
f0706e828e Jiri Benc              2007-05-05  3736  	int (*set_rts_threshold)(struct ieee80211_hw *hw, u32 value);
34e895075e Johannes Berg          2010-02-03  3737  	int (*sta_add)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
34e895075e Johannes Berg          2010-02-03  3738  		       struct ieee80211_sta *sta);
34e895075e Johannes Berg          2010-02-03  3739  	int (*sta_remove)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
34e895075e Johannes Berg          2010-02-03  3740  			  struct ieee80211_sta *sta);
77d2ece6fd Sujith Manoharan       2012-11-20  3741  #ifdef CONFIG_MAC80211_DEBUGFS
77d2ece6fd Sujith Manoharan       2012-11-20  3742  	void (*sta_add_debugfs)(struct ieee80211_hw *hw,
77d2ece6fd Sujith Manoharan       2012-11-20  3743  				struct ieee80211_vif *vif,
77d2ece6fd Sujith Manoharan       2012-11-20  3744  				struct ieee80211_sta *sta,
77d2ece6fd Sujith Manoharan       2012-11-20  3745  				struct dentry *dir);
77d2ece6fd Sujith Manoharan       2012-11-20  3746  #endif
32bfd35d4b Johannes Berg          2007-12-19  3747  	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
17741cdc26 Johannes Berg          2008-09-11  3748  			enum sta_notify_cmd, struct ieee80211_sta *sta);
54ad09a4dc Ashok Raj Nagarajan    2019-01-30  3749  	int (*sta_set_txpwr)(struct ieee80211_hw *hw,
54ad09a4dc Ashok Raj Nagarajan    2019-01-30  3750  			     struct ieee80211_vif *vif,
54ad09a4dc Ashok Raj Nagarajan    2019-01-30  3751  			     struct ieee80211_sta *sta);
f09603a259 Johannes Berg          2012-01-20  3752  	int (*sta_state)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
f09603a259 Johannes Berg          2012-01-20  3753  			 struct ieee80211_sta *sta,
f09603a259 Johannes Berg          2012-01-20  3754  			 enum ieee80211_sta_state old_state,
f09603a259 Johannes Berg          2012-01-20  3755  			 enum ieee80211_sta_state new_state);
6a9d1b91f3 Johannes Berg          2013-12-04  3756  	void (*sta_pre_rcu_remove)(struct ieee80211_hw *hw,
6a9d1b91f3 Johannes Berg          2013-12-04  3757  				   struct ieee80211_vif *vif,
6a9d1b91f3 Johannes Berg          2013-12-04  3758  				   struct ieee80211_sta *sta);
8f727ef3c4 Johannes Berg          2012-03-30  3759  	void (*sta_rc_update)(struct ieee80211_hw *hw,
8f727ef3c4 Johannes Berg          2012-03-30  3760  			      struct ieee80211_vif *vif,
8f727ef3c4 Johannes Berg          2012-03-30  3761  			      struct ieee80211_sta *sta,
8f727ef3c4 Johannes Berg          2012-03-30  3762  			      u32 changed);
f815e2b3c0 Johannes Berg          2014-11-19  3763  	void (*sta_rate_tbl_update)(struct ieee80211_hw *hw,
f815e2b3c0 Johannes Berg          2014-11-19  3764  				    struct ieee80211_vif *vif,
f815e2b3c0 Johannes Berg          2014-11-19  3765  				    struct ieee80211_sta *sta);
2b9a7e1bac Johannes Berg          2014-11-17  3766  	void (*sta_statistics)(struct ieee80211_hw *hw,
2b9a7e1bac Johannes Berg          2014-11-17  3767  			       struct ieee80211_vif *vif,
2b9a7e1bac Johannes Berg          2014-11-17  3768  			       struct ieee80211_sta *sta,
2b9a7e1bac Johannes Berg          2014-11-17  3769  			       struct station_info *sinfo);
8a3a3c85e4 Eliad Peller           2011-10-02  3770  	int (*conf_tx)(struct ieee80211_hw *hw,
a3304b0a17 Johannes Berg          2012-03-28  3771  		       struct ieee80211_vif *vif, u16 ac,
f0706e828e Jiri Benc              2007-05-05  3772  		       const struct ieee80211_tx_queue_params *params);
37a41b4aff Eliad Peller           2011-09-21  3773  	u64 (*get_tsf)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
37a41b4aff Eliad Peller           2011-09-21  3774  	void (*set_tsf)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
37a41b4aff Eliad Peller           2011-09-21  3775  			u64 tsf);
354d381baf Pedersen, Thomas       2016-09-28  3776  	void (*offset_tsf)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
354d381baf Pedersen, Thomas       2016-09-28  3777  			   s64 offset);
37a41b4aff Eliad Peller           2011-09-21  3778  	void (*reset_tsf)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
f0706e828e Jiri Benc              2007-05-05  3779  	int (*tx_last_beacon)(struct ieee80211_hw *hw);
57eeb2086d Johannes Berg          2017-01-13  3780  
57eeb2086d Johannes Berg          2017-01-13  3781  	/**
57eeb2086d Johannes Berg          2017-01-13  3782  	 * @ampdu_action:
57eeb2086d Johannes Berg          2017-01-13  3783  	 * Perform a certain A-MPDU action.
57eeb2086d Johannes Berg          2017-01-13  3784  	 * The RA/TID combination determines the destination and TID we want
57eeb2086d Johannes Berg          2017-01-13  3785  	 * the ampdu action to be performed for. The action is defined through
57eeb2086d Johannes Berg          2017-01-13  3786  	 * ieee80211_ampdu_mlme_action.
57eeb2086d Johannes Berg          2017-01-13  3787  	 * When the action is set to %IEEE80211_AMPDU_TX_OPERATIONAL the driver
57eeb2086d Johannes Berg          2017-01-13  3788  	 * may neither send aggregates containing more subframes than @buf_size
57eeb2086d Johannes Berg          2017-01-13  3789  	 * nor send aggregates in a way that lost frames would exceed the
57eeb2086d Johannes Berg          2017-01-13  3790  	 * buffer size. If just limiting the aggregate size, this would be
57eeb2086d Johannes Berg          2017-01-13  3791  	 * possible with a buf_size of 8:
57eeb2086d Johannes Berg          2017-01-13  3792  	 *
57eeb2086d Johannes Berg          2017-01-13  3793  	 * - ``TX: 1.....7``
57eeb2086d Johannes Berg          2017-01-13  3794  	 * - ``RX:  2....7`` (lost frame #1)
57eeb2086d Johannes Berg          2017-01-13  3795  	 * - ``TX:        8..1...``
57eeb2086d Johannes Berg          2017-01-13  3796  	 *
57eeb2086d Johannes Berg          2017-01-13  3797  	 * which is invalid since #1 was now re-transmitted well past the
57eeb2086d Johannes Berg          2017-01-13  3798  	 * buffer size of 8. Correct ways to retransmit #1 would be:
57eeb2086d Johannes Berg          2017-01-13  3799  	 *
57eeb2086d Johannes Berg          2017-01-13  3800  	 * - ``TX:        1   or``
57eeb2086d Johannes Berg          2017-01-13  3801  	 * - ``TX:        18  or``
57eeb2086d Johannes Berg          2017-01-13  3802  	 * - ``TX:        81``
57eeb2086d Johannes Berg          2017-01-13  3803  	 *
57eeb2086d Johannes Berg          2017-01-13  3804  	 * Even ``189`` would be wrong since 1 could be lost again.
57eeb2086d Johannes Berg          2017-01-13  3805  	 *
57eeb2086d Johannes Berg          2017-01-13  3806  	 * Returns a negative error code on failure.
57eeb2086d Johannes Berg          2017-01-13  3807  	 * The callback can sleep.
57eeb2086d Johannes Berg          2017-01-13  3808  	 */
1b7d03acbf Ron Rindjunsky         2007-12-25  3809  	int (*ampdu_action)(struct ieee80211_hw *hw,
c951ad3550 Johannes Berg          2009-11-16  3810  			    struct ieee80211_vif *vif,
50ea05efaf Sara Sharon            2015-12-30  3811  			    struct ieee80211_ampdu_params *params);
1289723ef2 Holger Schurig         2010-04-19  3812  	int (*get_survey)(struct ieee80211_hw *hw, int idx,
1289723ef2 Holger Schurig         2010-04-19  3813  		struct survey_info *survey);
1f87f7d3a3 Johannes Berg          2009-06-02  3814  	void (*rfkill_poll)(struct ieee80211_hw *hw);
a4bcaf5556 Lorenzo Bianconi       2014-09-04  3815  	void (*set_coverage_class)(struct ieee80211_hw *hw, s16 coverage_class);
aff89a9b90 Johannes Berg          2009-07-01  3816  #ifdef CONFIG_NL80211_TESTMODE
52981cd794 David Spinadel         2013-07-31  3817  	int (*testmode_cmd)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
52981cd794 David Spinadel         2013-07-31  3818  			    void *data, int len);
71063f0e89 Wey-Yi Guy             2011-05-20  3819  	int (*testmode_dump)(struct ieee80211_hw *hw, struct sk_buff *skb,
71063f0e89 Wey-Yi Guy             2011-05-20  3820  			     struct netlink_callback *cb,
71063f0e89 Wey-Yi Guy             2011-05-20  3821  			     void *data, int len);
aff89a9b90 Johannes Berg          2009-07-01  3822  #endif
77be2c54c5 Emmanuel Grumbach      2014-03-27  3823  	void (*flush)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
77be2c54c5 Emmanuel Grumbach      2014-03-27  3824  		      u32 queues, bool drop);
5ce6e438d5 Johannes Berg          2010-05-11  3825  	void (*channel_switch)(struct ieee80211_hw *hw,
0f791eb47f Luciano Coelho         2014-10-08  3826  			       struct ieee80211_vif *vif,
5ce6e438d5 Johannes Berg          2010-05-11  3827  			       struct ieee80211_channel_switch *ch_switch);
15d9675321 Bruno Randolf          2010-11-10  3828  	int (*set_antenna)(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant);
15d9675321 Bruno Randolf          2010-11-10  3829  	int (*get_antenna)(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant);
21f8358964 Johannes Berg          2010-12-18  3830  
21f8358964 Johannes Berg          2010-12-18  3831  	int (*remain_on_channel)(struct ieee80211_hw *hw,
4988456862 Eliad Peller           2012-11-19  3832  				 struct ieee80211_vif *vif,
21f8358964 Johannes Berg          2010-12-18  3833  				 struct ieee80211_channel *chan,
d339d5ca8e Ilan Peer              2013-02-12  3834  				 int duration,
d339d5ca8e Ilan Peer              2013-02-12  3835  				 enum ieee80211_roc_type type);
21f8358964 Johannes Berg          2010-12-18  3836  	int (*cancel_remain_on_channel)(struct ieee80211_hw *hw);
38c091590f John W. Linville       2011-03-07  3837  	int (*set_ringparam)(struct ieee80211_hw *hw, u32 tx, u32 rx);
38c091590f John W. Linville       2011-03-07  3838  	void (*get_ringparam)(struct ieee80211_hw *hw,
38c091590f John W. Linville       2011-03-07  3839  			      u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max);
e8306f9894 Vivek Natarajan        2011-04-06  3840  	bool (*tx_frames_pending)(struct ieee80211_hw *hw);
bdbfd6b582 Sujith Manoharan       2011-04-27  3841  	int (*set_bitrate_mask)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
bdbfd6b582 Sujith Manoharan       2011-04-27  3842  				const struct cfg80211_bitrate_mask *mask);
a818292952 Emmanuel Grumbach      2015-03-16  3843  	void (*event_callback)(struct ieee80211_hw *hw,
887da9176e Emmanuel Grumbach      2013-01-20  3844  			       struct ieee80211_vif *vif,
a818292952 Emmanuel Grumbach      2015-03-16  3845  			       const struct ieee80211_event *event);
4049e09acd Johannes Berg          2011-09-29  3846  
40b9640883 Johannes Berg          2011-09-29  3847  	void (*allow_buffered_frames)(struct ieee80211_hw *hw,
40b9640883 Johannes Berg          2011-09-29  3848  				      struct ieee80211_sta *sta,
40b9640883 Johannes Berg          2011-09-29  3849  				      u16 tids, int num_frames,
40b9640883 Johannes Berg          2011-09-29  3850  				      enum ieee80211_frame_release_type reason,
40b9640883 Johannes Berg          2011-09-29  3851  				      bool more_data);
4049e09acd Johannes Berg          2011-09-29  3852  	void (*release_buffered_frames)(struct ieee80211_hw *hw,
4049e09acd Johannes Berg          2011-09-29  3853  					struct ieee80211_sta *sta,
4049e09acd Johannes Berg          2011-09-29  3854  					u16 tids, int num_frames,
4049e09acd Johannes Berg          2011-09-29  3855  					enum ieee80211_frame_release_type reason,
4049e09acd Johannes Berg          2011-09-29  3856  					bool more_data);
e352114fd6 Ben Greear             2012-04-23  3857  
e352114fd6 Ben Greear             2012-04-23  3858  	int	(*get_et_sset_count)(struct ieee80211_hw *hw,
e352114fd6 Ben Greear             2012-04-23  3859  				     struct ieee80211_vif *vif, int sset);
e352114fd6 Ben Greear             2012-04-23  3860  	void	(*get_et_stats)(struct ieee80211_hw *hw,
e352114fd6 Ben Greear             2012-04-23  3861  				struct ieee80211_vif *vif,
e352114fd6 Ben Greear             2012-04-23  3862  				struct ethtool_stats *stats, u64 *data);
e352114fd6 Ben Greear             2012-04-23  3863  	void	(*get_et_strings)(struct ieee80211_hw *hw,
e352114fd6 Ben Greear             2012-04-23  3864  				  struct ieee80211_vif *vif,
e352114fd6 Ben Greear             2012-04-23  3865  				  u32 sset, u8 *data);
a1845fc7c5 Johannes Berg          2012-06-27  3866  
a1845fc7c5 Johannes Berg          2012-06-27  3867  	void	(*mgd_prepare_tx)(struct ieee80211_hw *hw,
d4e36e5554 Ilan Peer              2018-04-20  3868  				  struct ieee80211_vif *vif,
d4e36e5554 Ilan Peer              2018-04-20  3869  				  u16 duration);
c3645eac47 Michal Kazior          2012-06-26  3870  
ee10f2c779 Arik Nemtsov           2014-06-11  3871  	void	(*mgd_protect_tdls_discover)(struct ieee80211_hw *hw,
ee10f2c779 Arik Nemtsov           2014-06-11  3872  					     struct ieee80211_vif *vif);
ee10f2c779 Arik Nemtsov           2014-06-11  3873  
c3645eac47 Michal Kazior          2012-06-26  3874  	int (*add_chanctx)(struct ieee80211_hw *hw,
c3645eac47 Michal Kazior          2012-06-26  3875  			   struct ieee80211_chanctx_conf *ctx);
c3645eac47 Michal Kazior          2012-06-26  3876  	void (*remove_chanctx)(struct ieee80211_hw *hw,
c3645eac47 Michal Kazior          2012-06-26  3877  			       struct ieee80211_chanctx_conf *ctx);
c3645eac47 Michal Kazior          2012-06-26  3878  	void (*change_chanctx)(struct ieee80211_hw *hw,
c3645eac47 Michal Kazior          2012-06-26  3879  			       struct ieee80211_chanctx_conf *ctx,
c3645eac47 Michal Kazior          2012-06-26  3880  			       u32 changed);
c3645eac47 Michal Kazior          2012-06-26  3881  	int (*assign_vif_chanctx)(struct ieee80211_hw *hw,
c3645eac47 Michal Kazior          2012-06-26  3882  				  struct ieee80211_vif *vif,
c3645eac47 Michal Kazior          2012-06-26  3883  				  struct ieee80211_chanctx_conf *ctx);
c3645eac47 Michal Kazior          2012-06-26  3884  	void (*unassign_vif_chanctx)(struct ieee80211_hw *hw,
c3645eac47 Michal Kazior          2012-06-26  3885  				     struct ieee80211_vif *vif,
c3645eac47 Michal Kazior          2012-06-26  3886  				     struct ieee80211_chanctx_conf *ctx);
1a5f0c13d1 Luciano Coelho         2014-05-23  3887  	int (*switch_vif_chanctx)(struct ieee80211_hw *hw,
1a5f0c13d1 Luciano Coelho         2014-05-23  3888  				  struct ieee80211_vif_chanctx_switch *vifs,
1a5f0c13d1 Luciano Coelho         2014-05-23  3889  				  int n_vifs,
1a5f0c13d1 Luciano Coelho         2014-05-23  3890  				  enum ieee80211_chanctx_switch_mode mode);
9214ad7f9a Johannes Berg          2012-11-06  3891  
cf2c92d840 Eliad Peller           2014-11-04  3892  	void (*reconfig_complete)(struct ieee80211_hw *hw,
cf2c92d840 Eliad Peller           2014-11-04  3893  				  enum ieee80211_reconfig_type reconfig_type);
a65240c101 Johannes Berg          2013-01-14  3894  
a65240c101 Johannes Berg          2013-01-14  3895  #if IS_ENABLED(CONFIG_IPV6)
a65240c101 Johannes Berg          2013-01-14  3896  	void (*ipv6_addr_change)(struct ieee80211_hw *hw,
a65240c101 Johannes Berg          2013-01-14  3897  				 struct ieee80211_vif *vif,
a65240c101 Johannes Berg          2013-01-14  3898  				 struct inet6_dev *idev);
a65240c101 Johannes Berg          2013-01-14  3899  #endif
73da7d5bab Simon Wunderlich       2013-07-11  3900  	void (*channel_switch_beacon)(struct ieee80211_hw *hw,
73da7d5bab Simon Wunderlich       2013-07-11  3901  				      struct ieee80211_vif *vif,
73da7d5bab Simon Wunderlich       2013-07-11  3902  				      struct cfg80211_chan_def *chandef);
6d027bcc8a Luciano Coelho         2014-10-08  3903  	int (*pre_channel_switch)(struct ieee80211_hw *hw,
6d027bcc8a Luciano Coelho         2014-10-08  3904  				  struct ieee80211_vif *vif,
6d027bcc8a Luciano Coelho         2014-10-08  3905  				  struct ieee80211_channel_switch *ch_switch);
55fff50113 Johannes Berg          2013-08-19  3906  
f1d65583bc Luciano Coelho         2014-10-08  3907  	int (*post_channel_switch)(struct ieee80211_hw *hw,
f1d65583bc Luciano Coelho         2014-10-08  3908  				   struct ieee80211_vif *vif);
f1d65583bc Luciano Coelho         2014-10-08  3909  
55fff50113 Johannes Berg          2013-08-19  3910  	int (*join_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
55fff50113 Johannes Berg          2013-08-19  3911  	void (*leave_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
2439ca0402 Maxim Altshul          2016-08-04  3912  	u32 (*get_expected_throughput)(struct ieee80211_hw *hw,
2439ca0402 Maxim Altshul          2016-08-04  3913  				       struct ieee80211_sta *sta);
5b3dc42b1b Felix Fietkau          2014-10-26  3914  	int (*get_txpower)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
5b3dc42b1b Felix Fietkau          2014-10-26  3915  			   int *dbm);
a7a6bdd067 Arik Nemtsov           2014-11-09  3916  
a7a6bdd067 Arik Nemtsov           2014-11-09  3917  	int (*tdls_channel_switch)(struct ieee80211_hw *hw,
a7a6bdd067 Arik Nemtsov           2014-11-09  3918  				   struct ieee80211_vif *vif,
a7a6bdd067 Arik Nemtsov           2014-11-09  3919  				   struct ieee80211_sta *sta, u8 oper_class,
a7a6bdd067 Arik Nemtsov           2014-11-09  3920  				   struct cfg80211_chan_def *chandef,
8a4d32f30d Arik Nemtsov           2014-11-09  3921  				   struct sk_buff *tmpl_skb, u32 ch_sw_tm_ie);
a7a6bdd067 Arik Nemtsov           2014-11-09  3922  	void (*tdls_cancel_channel_switch)(struct ieee80211_hw *hw,
a7a6bdd067 Arik Nemtsov           2014-11-09  3923  					   struct ieee80211_vif *vif,
a7a6bdd067 Arik Nemtsov           2014-11-09  3924  					   struct ieee80211_sta *sta);
8a4d32f30d Arik Nemtsov           2014-11-09  3925  	void (*tdls_recv_channel_switch)(struct ieee80211_hw *hw,
8a4d32f30d Arik Nemtsov           2014-11-09  3926  					 struct ieee80211_vif *vif,
8a4d32f30d Arik Nemtsov           2014-11-09  3927  					 struct ieee80211_tdls_ch_sw_params *params);
ba8c3d6f16 Felix Fietkau          2015-03-27  3928  
e7881bd594 Johannes Berg          2017-12-19  3929  	void (*wake_tx_queue)(struct ieee80211_hw *hw,
e7881bd594 Johannes Berg          2017-12-19  3930  			      struct ieee80211_txq *txq);
f59374eb42 Sara Sharon            2016-03-02  3931  	void (*sync_rx_queues)(struct ieee80211_hw *hw);
708d50edb1 Ayala Beker            2016-09-20  3932  
708d50edb1 Ayala Beker            2016-09-20  3933  	int (*start_nan)(struct ieee80211_hw *hw,
708d50edb1 Ayala Beker            2016-09-20  3934  			 struct ieee80211_vif *vif,
708d50edb1 Ayala Beker            2016-09-20  3935  			 struct cfg80211_nan_conf *conf);
708d50edb1 Ayala Beker            2016-09-20  3936  	int (*stop_nan)(struct ieee80211_hw *hw,
708d50edb1 Ayala Beker            2016-09-20  3937  			struct ieee80211_vif *vif);
5953ff6d6a Ayala Beker            2016-09-20  3938  	int (*nan_change_conf)(struct ieee80211_hw *hw,
5953ff6d6a Ayala Beker            2016-09-20  3939  			       struct ieee80211_vif *vif,
5953ff6d6a Ayala Beker            2016-09-20  3940  			       struct cfg80211_nan_conf *conf, u32 changes);
167e33f4f6 Ayala Beker            2016-09-20  3941  	int (*add_nan_func)(struct ieee80211_hw *hw,
167e33f4f6 Ayala Beker            2016-09-20  3942  			    struct ieee80211_vif *vif,
167e33f4f6 Ayala Beker            2016-09-20  3943  			    const struct cfg80211_nan_func *nan_func);
167e33f4f6 Ayala Beker            2016-09-20  3944  	void (*del_nan_func)(struct ieee80211_hw *hw,
167e33f4f6 Ayala Beker            2016-09-20  3945  			    struct ieee80211_vif *vif,
167e33f4f6 Ayala Beker            2016-09-20  3946  			    u8 instance_id);
9739fe29a2 Sara Sharon            2018-09-05  3947  	bool (*can_aggregate_in_amsdu)(struct ieee80211_hw *hw,
9739fe29a2 Sara Sharon            2018-09-05  3948  				       struct sk_buff *head,
9739fe29a2 Sara Sharon            2018-09-05  3949  				       struct sk_buff *skb);
bc847970f4 Pradeep Kumar Chitrapu 2018-10-03  3950  	int (*get_ftm_responder_stats)(struct ieee80211_hw *hw,
bc847970f4 Pradeep Kumar Chitrapu 2018-10-03  3951  				       struct ieee80211_vif *vif,
bc847970f4 Pradeep Kumar Chitrapu 2018-10-03  3952  				       struct cfg80211_ftm_responder_stats *ftm_stats);
cee7013be9 Johannes Berg          2018-10-16  3953  	int (*start_pmsr)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
cee7013be9 Johannes Berg          2018-10-16  3954  			  struct cfg80211_pmsr_request *request);
cee7013be9 Johannes Berg          2018-10-16  3955  	void (*abort_pmsr)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
cee7013be9 Johannes Berg          2018-10-16  3956  			   struct cfg80211_pmsr_request *request);
f0706e828e Jiri Benc              2007-05-05 @3957  };
f0706e828e Jiri Benc              2007-05-05  3958  

:::::: The code at line 3957 was first introduced by commit
:::::: f0706e828e96d0fa4e80c0d25aa98523f6d589a0 [MAC80211]: Add mac80211 wireless stack.

:::::: TO: Jiri Benc <jbenc@suse.cz>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--/04w6evG8XlLl3ft
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICGTFUVwAAy5jb25maWcAjFxZc9u4ln7vX8FKV00ldSuJt/i6Z8oPEAhKaJEEQ4Ba/MJS
ZDpRtS15tHQn/37OAUlxO/Cdru5OjAOAWM7ynQX+/bffPXY67l5Wx8169fz8y/tebIv96lg8
ek+b5+J/PF95sTKe8KX5BJ3Dzfb08/Pm+u7W+/Lp4tPFx/36ypsW+23x7PHd9mnz/QSjN7vt
b7//Bv/+Do0vrzDR/r+97+v1xzvvvV9826y23t2nKxh9efOh/Bv05SoO5DjnPJc6H3N+/6tu
gh/ymUi1VPH93cXVxcW5b8ji8Zl00ZpiwnTOdJSPlVHNRDL9ms9VOm1aRpkMfSMjkYuFYaNQ
5FqlpqGbSSqYn8s4UPC/3DCNg+3Oxvaknr1DcTy9NusfpWoq4lzFuY6S1qdjaXIRz3KWjvNQ
RtLcX1/h+VRLVlEi4etGaONtDt52d8SJ69Gh4iys9/nuXTOuTchZZhQx2O4x1yw0OLRqnLCZ
yKcijUWYjx9ka6VtyggoVzQpfIgYTVk8uEYoF+GmIXTXdN5oe0HtPfY74LLeoi8e3h6t3ibf
EOfri4BlocknSpuYReL+3fvtblt8aF2TXuqZTDg5N0+V1nkkIpUuc2YM4xOyX6ZFKEfE9+1R
spRPgAFATOFbwBNhzabA897h9O3w63AsXho2HYtYpJJbkUhSNRItcWuR9ETNaUoqtEhnzCDj
RcoXXSkLVMqFX4mPjMcNVScs1QI7NW0c2HiqVQZj8jkzfOKr1gi7tXYXnxn2BhlFjZ57xkIJ
g0UeMm1yvuQhsW2rDWbNKfbIdj4xE7HRbxLzCPQF8//MtCH6RUrnWYJrqe/JbF6K/YG6qslD
nsAo5UvelohYIUX6oSDZxZJJykSOJ3h9dqepJjgqSYWIEgNzxKL9ybp9psIsNixdkvNXvdq0
0hQk2WezOvzlHWGr3mr76B2Oq+PBW63Xu9P2uNl+b/ZsJJ/mMCBnnCv4VslC508gi9l7asj0
UrQcLCPlmaeHpwxzLHOgtT8DP4JdgMOndLIuO7eH6954OS3/4hLaLNaV0eETkBbLPT3GnrPY
5COUCeiQxRFLchOO8iDM9KT9KT5OVZZoWsNMBJ8mSsJMcO1GpTTHlItAI2LnIvukImT0rY/C
KWjCmZW+1Cd2DFZZJXBp8kGgekCehj8iFvMOj/W7afgLMRsD3oRvgeLRPaOSSf/ytqVvQJBN
CNfIRWKVlUkZF70xCdfJFJYUMoNraqjl7bfXF4Gql6CLU/oMx8JEABLySn/QnZY60G/2CCYs
dgl2orRcELLbkj+46Sl9SZlDTrr7p8cyUNtB5lpxZsSCpIhEuc5BjmMWBj5JtBt00KyGddD0
BEwpSWGSNu7Mn0nYWnUf9JnCnCOWptJx7VMcuIzosaMkePOykZksgggosbFaAOFsswSYLQYb
AnLcUVZafCXGwyjh+8Lvczx8Mz+bsRYjXF7cDFRmBfCTYv+027+stuvCE38XW9DdDLQ4R+0N
tqvRpY7JfQH8VxJhz/ksghNRNCiaReX43Kp3F6cjamagHlOa23XIKLykw2zUXpYO1cg5Ho49
HYsa47m7BWD0QgmoIgXJVTQDdjtOWOoDHKC5GCBZIMOeWatoi7vb/LqFyuHntp+hTZpxq+l8
wUE/pg1RZSbJTG7VLjgDxfPT9dVHdObedbgNNlv+eP9utV//+Pzz7vbz2jp3B+v65Y/FU/nz
eRxaLl8kuc6SpONAgYHjU6tyh7QoynrWLkL7lsZ+PpIlgrq/e4vOFveXt3SHmjX+wzydbp3p
zlhXs9xvuzo1YTIXAKRMfwdsWZuUPPBbTmw61yLKF3wyZj5Y2XCsUmkmEYENAaSOUkSpPhrb
3vyoCRAXoSFeUDRwHwDfylhYy0n0AL4CgcqTMfCY6WkFLUyWoISW2AvAe9MhFoAOapLVKjBV
ijh6ksVTR7+EgfCQ3cr1yBF4VqUTAXZNy1HYX7LOdCLgphxki48mGXwlicDJBaEie9jDZaHt
Cfhp8A3LmfqMPNDjhzPsOC7dnpUug+1ZJdaRRpBO8DAelvlYu4Zn1udqkQOw6YKl4ZKjPyVa
fJGMS4wYgkIM9f1VL8qhGV41Shnep+AA72qXItnv1sXhsNt7x1+vJeJ+KlbH0744lIC8nOgB
UD6yOK2zIhoI4jYDwUyWihydXlpBj1XoB1LTDm0qDEAD4FTnBwCtcpPSVhPpYmGANZDd3gIu
1Y3IVNKLLHGviiRoxhS2kluo7LD0kyWwNuAFQKbjrBesadDCzd0tTfjyBsFo2hYiLYoWhCWI
bq3qb3qCpAA4jaSkJzqT36bTx1hTb2jq1LGx6b8d7Xd0O08zrWiWiEQQSC5UTFPnMuYTmXDH
QiryNW1wI9CnjnnHAqzoeHH5BjUPaewb8WUqF87znknGr3M6nmWJjrND6OcYxYwDfKAUVCbG
gSks06NHVRkRPZGBuf/S7hJeumkI6RLQQaW7qbOoqxOBu7sNPErQGt7e9JvVrNsC5ltGWWTt
ScAiGS7vb9t0q4rBx4t02g1WKC40CqoWIehFyiWFGUEl2523Qj11s728DtSqKSzyh42T5VjF
xCwgNixLhwRARbGOhGHkJ7KIl+2N6kmEKd0i8oL9SBJbjK0d1ghLwUaOxBiw0CVNBFU6JFXA
d0CAhg5r4aEkklZg9hJ5R6ZL+9TyJ152281xty+DQM0dNo4Enjlo5rlj95Y7xZjxJfgODiVr
FLDtiLZz8o72IUozNFLKgIV2BVgiyYHZQHLc29fuZcNxSlopxQpjdT1/tuaGknLTiYtVjbc3
lN8wi3QSgpG77gxpWhH9OJyxsssVHTxoyP9xhktqXRYjqiAA8Hl/8ZNflP/09kkAWWgFnuXp
MumD8ADgQEllBKC0AWg32SqLOh6Pke2WZpAh8lhYIwQMKGfi/qJ7AYlx84HVjeBuKI3+e5rZ
kJRDH5cRdrAtan5/e9PiNpPSzGTX/4b/iZNq8HycRKsHQfNIuosWHP0lGhc95JcXFxSfPuRX
Xy46TPqQX3e79mahp7mHadoZmYVw5VOYBh826y605rXJUkvwsBAxp8hulxW3tSOcijMLud8a
D07aOIbxV73hlUM58zUdbOKRb50z0Cg0rgWOk8EyD31DBY3aN12yb82pE2WSMBufsf/un2Lv
gW5dfS9eiu3Ron/GE+ntXjE/2/EAKh+LjkRQyqfrzOC07Qu2nyEZKBiG40H7ecG++N9TsV3/
8g7r1XPPBlizn3ZjW+eR8vG56Hfup0QsfXQ61Dv33idcesVx/elDeyg6+qOMSodUIQA0cJ3o
vna4TBy5giSp0JEEBHaiEWQszJcvFzT2tPK81MFouNvNdrX/5YmX0/Oqvu0ug17307oIHDHc
oUBB9Eh1ZGKcJTV7BZv9yz+rfeH5+83fZeyvic76NCcFMo3m4J8jx7q00FipcSjOXQcbM8X3
/cp7qr/+aL/eSpXZrPIs6hg4mZoMzveB9XVtJ42Pka7NsVije/zxsXgtto8oNo20tD+hyvhc
y3bULXkcyRKktdfwJ2ijPGQjQQmzndG6NhIjnllsdQumYjgC2J59QpiNGX0j43yk54PLkuAb
YHSLiO5M+0GHshX9cIoAxpweULZiiUNAJVOCLC7jjyJNAX3L+E9hf+51g4PqsyDuz844UWra
I6IAws9GjjOVEalXDSeMkl/lnKnAFygrVK1lMpjoAACk0qbkwspSkDK8ms8n0tg4LhFtAtS8
jBlKk7GpIDuiN2UqxqA4Y78M3VRXXWmYTj8tvrrOF0tJnAMn83wECy7zfj1aJBfAXg1Z2+X0
82iAPjBGk6UxAFE4OdkOJfeTCMR1YoAb48LgGviijEzZEdQkxPfrPEFaHRFadOpeGtl6m2pD
pkbOhjdfMmOuWSBqr7Q/VSWR1eUjYu31qMaVBTkOmq8yRwBTJjwv6yLqIh9iKxX8qgK4ZA88
qBButR/W7YcHa1tQhRA75EHWv0t2KbByM9JMQC+VF2aDaf1bJTL3feZUMxvMdSiHGPG7qIK+
xEUAfqpxvuDAtK2oA5CyEBQXqlARItOFhBawFAuiO/HzZhGdJESvg1iAl0NqoO6ouy6DqGRZ
6xcTtubkIcZmR3CaYA39FkFhRZccV8DtekBgPY3b6DgDytLUBU3pvJVDeIPUH16epKNPiumj
LO5kzeu2QQJ5cLoJ3Mr1VQ3DYRO6xhxjrmYfv60OxaP3V5mQfN3vnjbPncKR8yqwd14b5U4l
D8JkYFIs1+L8/t33f/2rWxWH5YZln072stVMbMBmxzVmNNuRkYrjqNBtxYsmFejhqWnWKXcb
oeKkoGhcpnYS2EAWY6duJVVFt5xU0t+ikWPnKVg21+A2sTu65xKUaBJQHAFfvmYiQ2UKm7DF
We4u6ZzqYBmxToHnIxHgH2gpqjo0yy3iZ7E+HVffngtbyerZSNOxA1RHMg4igwJP5+1Lsuap
TKjoYcmzKuswejUIm9+aNJKOYD9uqe+72jVHxcsOIH3UeHQDaPpm6KKOiUQszqyFavT7OSBS
0oitVoO7s+U2VlyOa1nmZjowA6atf0v9LCLL3NXo9sgy+QwnA7ru3K89MYaQEmNH2xjkTfvc
wK3hjmgKugC5UejetTc+1ZRvW5dzWoVdFvH56f3NxR+3rUgiYYeo4Gs7FTrteCUczHRsY+mO
MAHtWz4krrjBwyij3a4HPayz6GFnm3isPYdODF2kNh4NF+lI8AG4G4mYTyKWUvrqLK+JEaVF
7vIeuLdOjwjrZv60pZxWAPzi78267XB2OoMz3p5X9JzzDrDkHTcegwFEoIdLW9QQIrou286h
FRggto+vu8322AlWwxAwxhZR06EUjpxNe6CbdbUzTw3jM1lZCzMRYeIK/ouZiZLAkeA0AGcY
QglHrUk5/dk/twXjg2WeXf7n3erROt2NZz+Hs2K+Y23IfXNbG0gpt9YWMKPup4DQXXu0HcQs
dWSbyw5YQl9NA7YO0eQbnG/LHDKjHCXQSJ5lIdYOjCRoHynOaAQDSo+WJTtXNY61I0dgaPFU
gUtsIiwvOReTgLapqmeaiyubBjcVzyLh6dPr625/rN9hRJvDmlovXEe0REtOLg4kO1Qac/wY
ipbccfAakD6txq7IBQoB5x15h/MSmw9aSv7HNV/cDoaZ4ufq4Mnt4bg/vdjys8MPYMhH77hf
bQ84lQdgsPAeYa+bV/xrvXv2fCz2Ky9IxqwVPNr9s0Ve9l52jydACO8xCrnZF/CJK/6hHiq3
R0CaAGa8//L2xbN9GnPonm3TBZnCr2NSlqbBByGaZyohWpuJJrvD0Unkq/0j9Rln/93ruRJE
H2EHbRTxnisdfWip1fP6ztM1t8Mn1AOT0rFroJfmWla81jqqmleAiNikU7fAOOhMhWF7K7d6
cPVy+3o6DudsYrFxkg35bAIHZa9aflYeDulGvbGo/v8nfLZrxxkA15ZkbQ4cuVoDt1HCZgxd
Ow06zVW0CqSpi4arYqHVrL3AdXMuSSTzspjYUc8yfytjFM9ckp3wu39f3/7Mx4mjqjbW3E2E
FY3LVJg7n204/JfQXzci5H0PqfE17X4Ao2VYdZZkQ2a64iQPXdGQXF7T7dqV5UgimjDRdHuS
DBk+MYm3ft6t/+orG7G1Pk0yWeJrIMzqAIbCR22Ym7LHCeY+SrB09LiD+Qrv+KPwVo+PG4QV
q+dy1sOnDnKRsbPOCu+w9+7oTJvTeQmbpc/ZzFGebqmY3HSgJEtHTzKkpWUyjxwlQGYCPiCj
91G/KyIEXutRu7ywuUhNlQ+PAJuT3Uc90F7a3dPzcfN02q7x9GsF9jhMmkSBb1+C5Y6sJtIj
hFi0XzAxiBC05NfO0VMRJaGj+AknN7fXfzjqjYCsI1cWio0WXy4uLLZzj15q7irbArKROYuu
r78ssEqI+fQJpGKcgdepaG0RCV+yOv4whNj71euPzfpAib3vKBuE9tzH8h0+mI7xxHvPTo+b
HdjWc5XlB/oFLIt8L9x822NCbr87HQGWnM1ssF+9FN6309MTGAx/aDACWu4wIBhaAxVyn9p0
w8Iqi6lXBRmwvJqgjyONCW3tj2SteCHSB/Xa2Hh26Ca8Y8IzPcxCYptFZY9dcIHtyY9fB3xy
7IWrX2gshxIRq8R+ccGFnJGbQ+qY+WOHIjHLxCFMODBV+O5qLo3zueUoz8JEOk1rNqcvJ4oc
Eiwijc/aHGlecKGET3+pzPFI64EsicsUPuN1xE3zNGuVN1vS4CJT0Bag07sNEb+8ub27vKso
jdwZfNfIHG6Nj0pp4BmUDnvERllA1htg8A4Ds/R2s4UvdeJ6aJY5MIUN8hD4sdNBKriHeAgJ
os16vzvsno7e5Ndrsf84876fCoDghL4A8zp2vTfEjHxdi5wT59I4RhNwc8S5r+vRURiyWC3e
Lm+ezOtA6hCMWgChd6d9x+icQ1BTnfJc3l19aSUQoFXMDNE6Cv1zawu5y3Ck6NIFqaIoc6rk
tHjZHQt0TCjhR8fdoC84VL7p68vhOzkmiXR9y25lOJdEWYGG77zX9kWop7YA4jevH7zDa7He
PJ0DM2f1xV6ed9+hWe94X7ON9uBPrncvFC1eJJ+DfVFgiUvhfd3t5Veq2+ZTtKDav55WzzBz
f+rW5vDp8mBnC8yP/HQNWuAbo0U+4xl5YIll4n7xTeMOLozTqtsYNM0WjttJ5tFg9RiXWMNl
DN1IBgI2Bn0XsUUep+2ci0ww+ejS2hZ32kICMAAupyiIhmwH6LrzbLgByFWsCDuQxppH+VTF
DC3KlbMXgvdkwfKruzhCR4G2IZ1eOJ8bQXNHhU3Eh4aaKMSlNF/KhkqebR/3u81juxu4X6ly
VLT6zFHm1HeAS/99jqGd9Wb7nVbEtEIsqxgNbdZtCIhUDtKhxnQoox43VfFQEOOSHVpK1S/r
48Eha9XvtCQGdWGgy/xerhz1xDZniT1cdgZmqCpfpUMAfVuy4ZDAkpY7XzEH7I3RXzNl6CPE
QGqgb3JHGLoku6gBpv0cNAU2HeBAj1zywmr9o4eZ9SCtUjL5oTg97mwysLm1RmbA1Lg+b2l8
IkM/FfRp2xfdtHUuH5w5qOUf7kPBNKHlBviAEQ6YEIfDY9HF+rTfHH9R6Gsqlo4wruBZChAT
QJ3QVlXabP+bfbsLrzddl//g+1bLZrbCwaahWFmB0goF9brR3NGp3aJXZLON5zzwMFlSS0aV
32t2y1o5yj6189t2rMSpwWET3l3PNsBBxhxOIMDgNq6QqF+DLqGIHdRAxvVzy5EkfqEI5p56
pZvnB6xqmGS15XD4O1DsbzNIQtktV+QACzkHz5Bm2pRf0g8scJy5vPAlnVBHsjRZ7pz2mrZn
QLmlX50BxUmgYxng3NgPuWrHOf0srYwpXl9hjj3o/5KmBk494JtrUiA03kM7g142oTnIexW3
uvve2CaRtfW0wEWMx/9XyNU0tQ0D0Xt/Bcce2g5QZtoLB4U4iSexbGwH95ahaYYyGShTYKY/
v/shyba8qxyYQrWWra/dlfTea1cKPJcRkqsMb6VHowmxSMkn5nM5AJAqkCrbAF7BLsWe+DBQ
C/h9vz8yNIf+9+Xv4/PbkQ4sfz0dIIOfwBfgn6akwLckrmvgHn1TLW63edZeXwVQDYRbJJNM
argaiZF9JgEaiBv74yt90N6JlEneki8VUQBMzoEdCJ/OmvFEWxh9ZpV2prbXF+eXV+OerEin
TBWPQLQOvcE0crazteAx8IStmJWKeAUTbDqbvFeVHXmGR44Nt2w4p/iZhoG9GKYKox2kxEbU
EbvSbqSjjBEBd/pCkpXadZlZe1iFHDYNbg0gZtaSIgZXxTA3f2Xl0DXzw8/3h4eYhIbdR1Tj
Rs22xmxwfRSgZU1ptbSOq6lLFLiaSMFFVuUMYdVq9HWNBJfj8KDR474k8QZGcW6bCNsSWd2p
/BDyZGzDEPzpV7iCRPUOzISqQgmrBE2u7wxqD6aSiw2JmknN9cVCTQ4suzaNsd7nTqG0xiLu
kAUvqhvhLavort1hW2DenW3+7I/vL+ySVvfPD9H+ftFGaGo54ZyirpWOw0LIT8GVI0xdNOpu
xXuTwZy2sNBgcZfRVkYqD2y5USHeWCGGbsChYkI+Tz+Ufpj41ahPsYp1llXRsuLcDE/AwrI+
+/j68vhMF2Cfzp7e3w7/DvALUoG+EBnIJwm4OaO6lxTpwvnpcEtwl96iUR2Yk6ZWmHBwF89/
1FVK4l26jo1Qx6arjLLvZVv6KN1FsZE/Sd5Al56oC3vHVHnIBeTvpLfCPCSxCNWt9e1IpVi9
noxcCcYWaCBKq0HehBBS/XbbeUL2pKmW5klPXOWnLJqUu/fcitQY39TQFtvmRtjqoZ6dGLdQ
vY5IFGpnosXJcSEjtcNJIu/WOfrULHWakLtaD9u+J2LikHJGgds00cZnRoE7ougPjdk0ZBTT
KkLpsjbVSrbxZB+RDDUuJIKERHZxxQWD5OsMc/aYxMFsUP4Gpu3EPBP3YOHh964Qn1D82EIf
Wcd4TIxsjfyNgqcO1h/frAxPg9XpRbmMJU1PhRLdr31TVDKavqcPrJfz0e0V/p1KULYzDOfw
k7eoOMhEgT65xtJ0foMHl6hYTCjHocwajyhE+8XGLBup8/G2CPKNWdkQH7hVNBcZnZtQ9aNb
p/YEsLKTTzeZk6SLm7kIu5mR4qTW9UWRl8oiy0vWsaLr2N35j+/nfQYQl2UDAYpx2Za1sC7l
UmIsfZ2U0cuGhN2+QJFdCxb8vrSNjQC1ocecaxp+4jC9ualMYlEF8UuvQJUYFggJyiVL0EXZ
LcbONuwau9zC1k7fcAULlDkarbn/oVaGgjVcAAA=

--/04w6evG8XlLl3ft--
