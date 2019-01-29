Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2827AC169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 11:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1DB52087F
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 11:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfA2LUb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 06:20:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:58686 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbfA2LUb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 06:20:31 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2019 03:20:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,537,1539673200"; 
   d="gz'50?scan'50,208,50";a="110678181"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 29 Jan 2019 03:20:28 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1goRRM-000GAF-4z; Tue, 29 Jan 2019 19:20:28 +0800
Date:   Tue, 29 Jan 2019 19:19:52 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Julan Hsu <julanhsu@google.com>
Cc:     kbuild-all@01.org, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [mac80211-next:master 6/17] htmldocs: include/net/cfg80211.h:1444:
 warning: Enum value 'MPATH_INFO_PATH_CHANGE' not described in enum
 'mpath_info_flags'
Message-ID: <201901291945.GUE7RQFq%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
head:   6c900360e7c0df6a4846ac97d7b548d72cd801b0
commit: 540bbcb930ed2fc9d6a57e0babea00027a7ecc67 [6/17] nl80211/mac80211: mesh: add mesh path change count to mpath info
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   WARNING: convert(1) not found, for SVG to PDF conversion install ImageMagick (https://www.imagemagick.org)
   include/linux/interrupt.h:268: warning: Function parameter or member 'is_managed' not described in 'irq_affinity_desc'
   include/linux/rcupdate_wait.h:1: warning: no structured comments found
   include/linux/rcutree.h:1: warning: no structured comments found
   kernel/rcu/tree.c:710: warning: Excess function parameter 'irq' description in 'rcu_nmi_exit'
   include/linux/gfp.h:1: warning: no structured comments found
   include/net/cfg80211.h:4703: warning: Function parameter or member 'wext.ibss' not described in 'wireless_dev'
   include/net/cfg80211.h:4703: warning: Function parameter or member 'wext.connect' not described in 'wireless_dev'
   include/net/cfg80211.h:4703: warning: Function parameter or member 'wext.keys' not described in 'wireless_dev'
   include/net/cfg80211.h:4703: warning: Function parameter or member 'wext.ie' not described in 'wireless_dev'
   include/net/cfg80211.h:4703: warning: Function parameter or member 'wext.ie_len' not described in 'wireless_dev'
   include/net/cfg80211.h:4703: warning: Function parameter or member 'wext.bssid' not described in 'wireless_dev'
   include/net/cfg80211.h:4703: warning: Function parameter or member 'wext.ssid' not described in 'wireless_dev'
   include/net/cfg80211.h:4703: warning: Function parameter or member 'wext.default_key' not described in 'wireless_dev'
   include/net/cfg80211.h:4703: warning: Function parameter or member 'wext.default_mgmt_key' not described in 'wireless_dev'
   include/net/cfg80211.h:4703: warning: Function parameter or member 'wext.prev_bssid_valid' not described in 'wireless_dev'
>> include/net/cfg80211.h:1444: warning: Enum value 'MPATH_INFO_PATH_CHANGE' not described in enum 'mpath_info_flags'
   include/net/mac80211.h:2403: warning: Function parameter or member 'radiotap_timestamp.units_pos' not described in 'ieee80211_hw'
   include/net/mac80211.h:2403: warning: Function parameter or member 'radiotap_timestamp.accuracy' not described in 'ieee80211_hw'
   include/net/mac80211.h:2403: warning: Function parameter or member 'weight_multiplier' not described in 'ieee80211_hw'
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
   net/mac80211/sta_info.h:603: warning: Function parameter or member 'rx_stats_avg' not described in 'sta_info'
   net/mac80211/sta_info.h:603: warning: Function parameter or member 'rx_stats_avg.signal' not described in 'sta_info'
   net/mac80211/sta_info.h:603: warning: Function parameter or member 'rx_stats_avg.chain_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:603: warning: Function parameter or member 'status_stats.filtered' not described in 'sta_info'
   net/mac80211/sta_info.h:603: warning: Function parameter or member 'status_stats.retry_failed' not described in 'sta_info'
   net/mac80211/sta_info.h:603: warning: Function parameter or member 'status_stats.retry_count' not described in 'sta_info'
   net/mac80211/sta_info.h:603: warning: Function parameter or member 'status_stats.lost_packets' not described in 'sta_info'
   net/mac80211/sta_info.h:603: warning: Function parameter or member 'status_stats.last_tdls_pkt_time' not described in 'sta_info'
   net/mac80211/sta_info.h:603: warning: Function parameter or member 'status_stats.msdu_retries' not described in 'sta_info'
   net/mac80211/sta_info.h:603: warning: Function parameter or member 'status_stats.msdu_failed' not described in 'sta_info'
   net/mac80211/sta_info.h:603: warning: Function parameter or member 'status_stats.last_ack' not described in 'sta_info'
   net/mac80211/sta_info.h:603: warning: Function parameter or member 'status_stats.last_ack_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:603: warning: Function parameter or member 'status_stats.ack_signal_filled' not described in 'sta_info'
   net/mac80211/sta_info.h:603: warning: Function parameter or member 'status_stats.avg_ack_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:603: warning: Function parameter or member 'tx_stats.packets' not described in 'sta_info'
   net/mac80211/sta_info.h:603: warning: Function parameter or member 'tx_stats.bytes' not described in 'sta_info'
   net/mac80211/sta_info.h:603: warning: Function parameter or member 'tx_stats.last_rate' not described in 'sta_info'
   net/mac80211/sta_info.h:603: warning: Function parameter or member 'tx_stats.msdu' not described in 'sta_info'
   net/mac80211/sta_info.h:603: warning: Function parameter or member 'airtime' not described in 'sta_info'
   net/mac80211/sta_info.h:603: warning: Function parameter or member 'airtime_weight' not described in 'sta_info'
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

vim +1444 include/net/cfg80211.h

66f7ac50 Michael Wu       2008-01-31  1418  
2ec600d6 Luis Carlos Cobo 2008-02-23  1419  /**
2ec600d6 Luis Carlos Cobo 2008-02-23  1420   * enum mpath_info_flags -  mesh path information flags
2ec600d6 Luis Carlos Cobo 2008-02-23  1421   *
2ec600d6 Luis Carlos Cobo 2008-02-23  1422   * Used by the driver to indicate which info in &struct mpath_info it has filled
2ec600d6 Luis Carlos Cobo 2008-02-23  1423   * in during get_station() or dump_station().
2ec600d6 Luis Carlos Cobo 2008-02-23  1424   *
abe37c4b Johannes Berg    2010-06-07  1425   * @MPATH_INFO_FRAME_QLEN: @frame_qlen filled
abe37c4b Johannes Berg    2010-06-07  1426   * @MPATH_INFO_SN: @sn filled
abe37c4b Johannes Berg    2010-06-07  1427   * @MPATH_INFO_METRIC: @metric filled
abe37c4b Johannes Berg    2010-06-07  1428   * @MPATH_INFO_EXPTIME: @exptime filled
abe37c4b Johannes Berg    2010-06-07  1429   * @MPATH_INFO_DISCOVERY_TIMEOUT: @discovery_timeout filled
abe37c4b Johannes Berg    2010-06-07  1430   * @MPATH_INFO_DISCOVERY_RETRIES: @discovery_retries filled
abe37c4b Johannes Berg    2010-06-07  1431   * @MPATH_INFO_FLAGS: @flags filled
cc241636 Julan Hsu        2019-01-15  1432   * @MPATH_INFO_HOP_COUNT: @hop_count filled
2ec600d6 Luis Carlos Cobo 2008-02-23  1433   */
2ec600d6 Luis Carlos Cobo 2008-02-23  1434  enum mpath_info_flags {
2ec600d6 Luis Carlos Cobo 2008-02-23  1435  	MPATH_INFO_FRAME_QLEN		= BIT(0),
d19b3bf6 Rui Paulo        2009-11-09  1436  	MPATH_INFO_SN			= BIT(1),
2ec600d6 Luis Carlos Cobo 2008-02-23  1437  	MPATH_INFO_METRIC		= BIT(2),
2ec600d6 Luis Carlos Cobo 2008-02-23  1438  	MPATH_INFO_EXPTIME		= BIT(3),
2ec600d6 Luis Carlos Cobo 2008-02-23  1439  	MPATH_INFO_DISCOVERY_TIMEOUT	= BIT(4),
2ec600d6 Luis Carlos Cobo 2008-02-23  1440  	MPATH_INFO_DISCOVERY_RETRIES	= BIT(5),
2ec600d6 Luis Carlos Cobo 2008-02-23  1441  	MPATH_INFO_FLAGS		= BIT(6),
540bbcb9 Julan Hsu        2019-01-15  1442  	MPATH_INFO_HOP_COUNT		= BIT(7),
540bbcb9 Julan Hsu        2019-01-15  1443  	MPATH_INFO_PATH_CHANGE		= BIT(8),
2ec600d6 Luis Carlos Cobo 2008-02-23 @1444  };
2ec600d6 Luis Carlos Cobo 2008-02-23  1445  

:::::: The code at line 1444 was first introduced by commit
:::::: 2ec600d672e74488f8d1acf67a0a2baed222564c nl80211/cfg80211: support for mesh, sta dumping

:::::: TO: Luis Carlos Cobo <luisca@cozybit.com>
:::::: CC: John W. Linville <linville@tuxdriver.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--qMm9M+Fa2AknHoGS
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
LcbONuwau9zC1k7fcAULlDkarbn/oVaGgjVcAAA=

--qMm9M+Fa2AknHoGS--
