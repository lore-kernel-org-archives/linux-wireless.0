Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:37310 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932544AbeFZL2M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 07:28:12 -0400
Date: Tue, 26 Jun 2018 19:27:18 +0800
From: kbuild test robot <lkp@intel.com>
To: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc: kbuild-all@01.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Subject: Re: [PATCH] mac80211: add stop/start logic for software TXQs
Message-ID: <201806261702.HO7t0zBh%fengguang.wu@intel.com> (sfid-20180626_132817_993274_43DDD8C5)
References: <1529997415-20551-1-git-send-email-mpubbise@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="dDRMvlgZJXvWKvBx"
In-Reply-To: <1529997415-20551-1-git-send-email-mpubbise@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Manikanta,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mac80211-next/master]
[also build test WARNING on v4.18-rc2 next-20180626]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Manikanta-Pubbisetty/mac80211-add-stop-start-logic-for-software-TXQs/20180626-153410
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   WARNING: convert(1) not found, for SVG to PDF conversion install ImageMagick (https://www.imagemagick.org)
   mm/mempool.c:228: warning: Function parameter or member 'pool' not described in 'mempool_init'
   Error: Cannot open file arch/x86/kernel/cpu/mtrr/main.c
   Error: Cannot open file arch/x86/kernel/cpu/mtrr/main.c
   WARNING: kernel-doc 'scripts/kernel-doc -rst -enable-lineno -export arch/x86/kernel/cpu/mtrr/main.c' failed with return code 2
   include/net/cfg80211.h:4381: warning: Function parameter or member 'wext.ibss' not described in 'wireless_dev'
   include/net/cfg80211.h:4381: warning: Function parameter or member 'wext.connect' not described in 'wireless_dev'
   include/net/cfg80211.h:4381: warning: Function parameter or member 'wext.keys' not described in 'wireless_dev'
   include/net/cfg80211.h:4381: warning: Function parameter or member 'wext.ie' not described in 'wireless_dev'
   include/net/cfg80211.h:4381: warning: Function parameter or member 'wext.ie_len' not described in 'wireless_dev'
   include/net/cfg80211.h:4381: warning: Function parameter or member 'wext.bssid' not described in 'wireless_dev'
   include/net/cfg80211.h:4381: warning: Function parameter or member 'wext.ssid' not described in 'wireless_dev'
   include/net/cfg80211.h:4381: warning: Function parameter or member 'wext.default_key' not described in 'wireless_dev'
   include/net/cfg80211.h:4381: warning: Function parameter or member 'wext.default_mgmt_key' not described in 'wireless_dev'
   include/net/cfg80211.h:4381: warning: Function parameter or member 'wext.prev_bssid_valid' not described in 'wireless_dev'
   include/net/mac80211.h:2328: warning: Function parameter or member 'radiotap_timestamp.units_pos' not described in 'ieee80211_hw'
   include/net/mac80211.h:2328: warning: Function parameter or member 'radiotap_timestamp.accuracy' not described in 'ieee80211_hw'
   include/net/mac80211.h:977: warning: Function parameter or member 'control.rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'control.rts_cts_rate_idx' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'control.use_rts' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'control.use_cts_prot' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'control.short_preamble' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'control.skip_table' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'control.jiffies' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'control.vif' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'control.hw_key' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'control.flags' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'control.enqueue_time' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'ack' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'ack.cookie' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'status.rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'status.ack_signal' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'status.ampdu_ack_len' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'status.ampdu_len' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'status.antenna' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'status.tx_time' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'status.is_valid_ack_signal' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'status.status_driver_data' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'driver_rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'pad' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'rate_driver_data' not described in 'ieee80211_tx_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'rx_stats_avg' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'rx_stats_avg.signal' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'rx_stats_avg.chain_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'status_stats.filtered' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'status_stats.retry_failed' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'status_stats.retry_count' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'status_stats.lost_packets' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'status_stats.last_tdls_pkt_time' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'status_stats.msdu_retries' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'status_stats.msdu_failed' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'status_stats.last_ack' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'status_stats.last_ack_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'status_stats.ack_signal_filled' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'status_stats.avg_ack_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'tx_stats.packets' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'tx_stats.bytes' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'tx_stats.last_rate' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'tx_stats.msdu' not described in 'sta_info'
>> net/mac80211/sta_info.h:589: warning: Function parameter or member 'txqs_paused' not described in 'sta_info'
   kernel/sched/fair.c:3760: warning: Function parameter or member 'flags' not described in 'attach_entity_load_avg'
   include/linux/device.h:93: warning: bad line: this bus.
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_excl.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_excl.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_excl.active' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_shared.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_shared.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_shared.active' not described in 'dma_buf'
   include/linux/dma-fence-array.h:54: warning: Function parameter or member 'work' not described in 'dma_fence_array'
   include/linux/gpio/driver.h:142: warning: Function parameter or member 'request_key' not described in 'gpio_irq_chip'
   include/linux/iio/hw-consumer.h:1: warning: no structured comments found
   include/linux/device.h:94: warning: bad line: this bus.
   include/linux/input/sparse-keymap.h:46: warning: Function parameter or member 'sw' not described in 'key_entry'
   include/linux/regulator/driver.h:227: warning: Function parameter or member 'resume_early' not described in 'regulator_ops'
   drivers/regulator/core.c:4465: warning: Excess function parameter 'state' description in 'regulator_suspend_late'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw0' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw1' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw2' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw3' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.eadm' not described in 'irb'
   drivers/usb/dwc3/gadget.c:510: warning: Excess function parameter 'dwc' description in 'dwc3_gadget_start_config'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_pin' not described in 'drm_driver'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_unpin' not described in 'drm_driver'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_res_obj' not described in 'drm_driver'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_get_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_import_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_vmap' not described in 'drm_driver'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_vunmap' not described in 'drm_driver'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_mmap' not described in 'drm_driver'
   drivers/gpu/drm/i915/i915_vma.h:48: warning: cannot understand function prototype: 'struct i915_vma '
   drivers/gpu/drm/i915/i915_vma.h:1: warning: no structured comments found
   include/drm/tinydrm/tinydrm.h:34: warning: Function parameter or member 'fb_dirty' not described in 'tinydrm_device'
   drivers/gpu/drm/tinydrm/mipi-dbi.c:272: warning: Function parameter or member 'crtc_state' not described in 'mipi_dbi_enable_flush'
   drivers/gpu/drm/tinydrm/mipi-dbi.c:272: warning: Function parameter or member 'plane_state' not described in 'mipi_dbi_enable_flush'

vim +589 net/mac80211/sta_info.h

17741cdc2 Johannes Berg          2008-09-11  574  
0af83d3df Johannes Berg          2012-12-27  575  	enum ieee80211_sta_rx_bandwidth cur_max_bandwidth;
0af83d3df Johannes Berg          2012-12-27  576  
687da1322 Emmanuel Grumbach      2013-10-01  577  	enum ieee80211_smps_mode known_smps_mode;
2475b1cc0 Max Stepanov           2013-03-24  578  	const struct ieee80211_cipher_scheme *cipher_scheme;
687da1322 Emmanuel Grumbach      2013-10-01  579  
484a54c2e Toke Høiland-Jørgensen 2017-04-06  580  	struct codel_params cparams;
484a54c2e Toke Høiland-Jørgensen 2017-04-06  581  
b6da911b3 Liad Kaufman           2014-11-19  582  	u8 reserved_tid;
b6da911b3 Liad Kaufman           2014-11-19  583  
0fabfaafe Arik Nemtsov           2015-06-10  584  	struct cfg80211_chan_def tdls_chandef;
061b82d2b Manikanta Pubbisetty   2018-06-26  585  	atomic_t txqs_paused;
0fabfaafe Arik Nemtsov           2015-06-10  586  
17741cdc2 Johannes Berg          2008-09-11  587  	/* keep last! */
17741cdc2 Johannes Berg          2008-09-11  588  	struct ieee80211_sta sta;
f0706e828 Jiri Benc              2007-05-05 @589  };
f0706e828 Jiri Benc              2007-05-05  590  

:::::: The code at line 589 was first introduced by commit
:::::: f0706e828e96d0fa4e80c0d25aa98523f6d589a0 [MAC80211]: Add mac80211 wireless stack.

:::::: TO: Jiri Benc <jbenc@suse.cz>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--dDRMvlgZJXvWKvBx
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--dDRMvlgZJXvWKvBx--
