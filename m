Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:39980 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731716AbeGZX7Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jul 2018 19:59:25 -0400
Date: Thu, 26 Jul 2018 22:52:00 +0800
From: kbuild test robot <lkp@intel.com>
To: Wen Gong <wgong@codeaurora.org>
Cc: kbuild-all@01.org, ath10k@lists.infradead.org,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: Save sk_pacing_shift to ieee80211_hw
Message-ID: <201807262252.r7bjxM51%fengguang.wu@intel.com> (sfid-20180727_004035_268279_1019758C)
References: <1532589677-16428-2-git-send-email-wgong@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WIyZ46R2i8wDzkSu"
In-Reply-To: <1532589677-16428-2-git-send-email-wgong@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Wen,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mac80211-next/master]
[also build test WARNING on v4.18-rc6 next-20180725]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Wen-Gong/Change-sk_pacing_shift-in-ieee80211_hw-for-best-tx-throughput/20180726-190055
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   WARNING: convert(1) not found, for SVG to PDF conversion install ImageMagick (https://www.imagemagick.org)
   mm/mempool.c:228: warning: Function parameter or member 'pool' not described in 'mempool_init'
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
   include/net/mac80211.h:2329: warning: Function parameter or member 'radiotap_timestamp.units_pos' not described in 'ieee80211_hw'
   include/net/mac80211.h:2329: warning: Function parameter or member 'radiotap_timestamp.accuracy' not described in 'ieee80211_hw'
>> include/net/mac80211.h:2329: warning: Function parameter or member 'tx_sk_pacing_shift' not described in 'ieee80211_hw'
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
   include/linux/skbuff.h:853: warning: Function parameter or member 'dev_scratch' not described in 'sk_buff'
   include/linux/skbuff.h:853: warning: Function parameter or member 'ip_defrag_offset' not described in 'sk_buff'
   include/linux/skbuff.h:853: warning: Function parameter or member 'list' not described in 'sk_buff'
   include/linux/skbuff.h:853: warning: Function parameter or member 'skb_mstamp' not described in 'sk_buff'
   include/linux/skbuff.h:853: warning: Function parameter or member '__cloned_offset' not described in 'sk_buff'
   include/linux/skbuff.h:853: warning: Function parameter or member 'head_frag' not described in 'sk_buff'
   include/linux/skbuff.h:853: warning: Function parameter or member '__unused' not described in 'sk_buff'
   include/linux/skbuff.h:853: warning: Function parameter or member '__pkt_type_offset' not described in 'sk_buff'
   include/linux/skbuff.h:853: warning: Function parameter or member 'pfmemalloc' not described in 'sk_buff'
   include/linux/skbuff.h:853: warning: Function parameter or member 'encapsulation' not described in 'sk_buff'
   include/linux/skbuff.h:853: warning: Function parameter or member 'encap_hdr_csum' not described in 'sk_buff'
   include/linux/skbuff.h:853: warning: Function parameter or member 'csum_valid' not described in 'sk_buff'
   include/linux/skbuff.h:853: warning: Function parameter or member 'csum_complete_sw' not described in 'sk_buff'
   include/linux/skbuff.h:853: warning: Function parameter or member 'csum_level' not described in 'sk_buff'
   include/linux/skbuff.h:853: warning: Function parameter or member 'inner_protocol_type' not described in 'sk_buff'
   include/linux/skbuff.h:853: warning: Function parameter or member 'remcsum_offload' not described in 'sk_buff'
   include/linux/skbuff.h:853: warning: Function parameter or member 'offload_fwd_mark' not described in 'sk_buff'
   include/linux/skbuff.h:853: warning: Function parameter or member 'offload_mr_fwd_mark' not described in 'sk_buff'
   include/linux/skbuff.h:853: warning: Function parameter or member 'sender_cpu' not described in 'sk_buff'
   include/linux/skbuff.h:853: warning: Function parameter or member 'reserved_tailroom' not described in 'sk_buff'
   include/linux/skbuff.h:853: warning: Function parameter or member 'inner_ipproto' not described in 'sk_buff'
   include/net/sock.h:238: warning: Function parameter or member 'skc_addrpair' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_portpair' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_ipv6only' not described in 'sock_common'

vim +2329 include/net/mac80211.h

1bc0826c8f Johannes Berg    2007-09-18  2179  
7ac1bd6aec Johannes Berg    2007-09-14  2180  /**
7ac1bd6aec Johannes Berg    2007-09-14  2181   * struct ieee80211_hw - hardware information and state
75a5f0ccfd Johannes Berg    2007-09-18  2182   *
75a5f0ccfd Johannes Berg    2007-09-18  2183   * This structure contains the configuration and hardware
75a5f0ccfd Johannes Berg    2007-09-18  2184   * information for an 802.11 PHY.
75a5f0ccfd Johannes Berg    2007-09-18  2185   *
75a5f0ccfd Johannes Berg    2007-09-18  2186   * @wiphy: This points to the &struct wiphy allocated for this
75a5f0ccfd Johannes Berg    2007-09-18  2187   *	802.11 PHY. You must fill in the @perm_addr and @dev
75a5f0ccfd Johannes Berg    2007-09-18  2188   *	members of this structure using SET_IEEE80211_DEV()
8318d78a44 Johannes Berg    2008-01-24  2189   *	and SET_IEEE80211_PERM_ADDR(). Additionally, all supported
8318d78a44 Johannes Berg    2008-01-24  2190   *	bands (with channels, bitrates) are registered here.
75a5f0ccfd Johannes Berg    2007-09-18  2191   *
75a5f0ccfd Johannes Berg    2007-09-18  2192   * @conf: &struct ieee80211_conf, device configuration, don't use.
75a5f0ccfd Johannes Berg    2007-09-18  2193   *
75a5f0ccfd Johannes Berg    2007-09-18  2194   * @priv: pointer to private area that was allocated for driver use
75a5f0ccfd Johannes Berg    2007-09-18  2195   *	along with this structure.
75a5f0ccfd Johannes Berg    2007-09-18  2196   *
75a5f0ccfd Johannes Berg    2007-09-18  2197   * @flags: hardware flags, see &enum ieee80211_hw_flags.
75a5f0ccfd Johannes Berg    2007-09-18  2198   *
75a5f0ccfd Johannes Berg    2007-09-18  2199   * @extra_tx_headroom: headroom to reserve in each transmit skb
75a5f0ccfd Johannes Berg    2007-09-18  2200   *	for use by the driver (e.g. for transmit headers.)
75a5f0ccfd Johannes Berg    2007-09-18  2201   *
70dabeb74e Felix Fietkau    2013-12-14  2202   * @extra_beacon_tailroom: tailroom to reserve in each beacon tx skb.
70dabeb74e Felix Fietkau    2013-12-14  2203   *	Can be used by drivers to add extra IEs.
75a5f0ccfd Johannes Berg    2007-09-18  2204   *
566bfe5a8b Bruno Randolf    2008-05-08  2205   * @max_signal: Maximum value for signal (rssi) in RX information, used
566bfe5a8b Bruno Randolf    2008-05-08  2206   *	only when @IEEE80211_HW_SIGNAL_UNSPEC or @IEEE80211_HW_SIGNAL_DB
75a5f0ccfd Johannes Berg    2007-09-18  2207   *
ea95bba41e Tomas Winkler    2008-07-18  2208   * @max_listen_interval: max listen interval in units of beacon interval
ea95bba41e Tomas Winkler    2008-07-18  2209   *	that HW supports
ea95bba41e Tomas Winkler    2008-07-18  2210   *
75a5f0ccfd Johannes Berg    2007-09-18  2211   * @queues: number of available hardware transmit queues for
e100bb64bf Johannes Berg    2008-04-30  2212   *	data packets. WMM/QoS requires at least four, these
e100bb64bf Johannes Berg    2008-04-30  2213   *	queues need to have configurable access parameters.
e100bb64bf Johannes Berg    2008-04-30  2214   *
830f903866 Johannes Berg    2007-10-28  2215   * @rate_control_algorithm: rate control algorithm for this hardware.
830f903866 Johannes Berg    2007-10-28  2216   *	If unset (NULL), the default algorithm will be used. Must be
830f903866 Johannes Berg    2007-10-28  2217   *	set before calling ieee80211_register_hw().
32bfd35d4b Johannes Berg    2007-12-19  2218   *
32bfd35d4b Johannes Berg    2007-12-19  2219   * @vif_data_size: size (in bytes) of the drv_priv data area
32bfd35d4b Johannes Berg    2007-12-19  2220   *	within &struct ieee80211_vif.
17741cdc26 Johannes Berg    2008-09-11  2221   * @sta_data_size: size (in bytes) of the drv_priv data area
17741cdc26 Johannes Berg    2008-09-11  2222   *	within &struct ieee80211_sta.
d01a1e6586 Michal Kazior    2012-06-26  2223   * @chanctx_data_size: size (in bytes) of the drv_priv data area
d01a1e6586 Michal Kazior    2012-06-26  2224   *	within &struct ieee80211_chanctx_conf.
ba8c3d6f16 Felix Fietkau    2015-03-27  2225   * @txq_data_size: size (in bytes) of the drv_priv data area
ba8c3d6f16 Felix Fietkau    2015-03-27  2226   *	within @struct ieee80211_txq.
870abdf671 Felix Fietkau    2008-10-05  2227   *
78be49ec2a Helmut Schaa     2010-10-02  2228   * @max_rates: maximum number of alternate rate retry stages the hw
78be49ec2a Helmut Schaa     2010-10-02  2229   *	can handle.
78be49ec2a Helmut Schaa     2010-10-02  2230   * @max_report_rates: maximum number of alternate rate retry stages
78be49ec2a Helmut Schaa     2010-10-02  2231   *	the hw can report back.
e6a9854b05 Johannes Berg    2008-10-21  2232   * @max_rate_tries: maximum number of tries for each stage
4e6cbfd09c John W. Linville 2010-07-29  2233   *
df6ba5d80d Luciano Coelho   2011-01-12  2234   * @max_rx_aggregation_subframes: maximum buffer size (number of
df6ba5d80d Luciano Coelho   2011-01-12  2235   *	sub-frames) to be used for A-MPDU block ack receiver
df6ba5d80d Luciano Coelho   2011-01-12  2236   *	aggregation.
df6ba5d80d Luciano Coelho   2011-01-12  2237   *	This is only relevant if the device has restrictions on the
df6ba5d80d Luciano Coelho   2011-01-12  2238   *	number of subframes, if it relies on mac80211 to do reordering
df6ba5d80d Luciano Coelho   2011-01-12  2239   *	it shouldn't be set.
5dd36bc933 Johannes Berg    2011-01-18  2240   *
5dd36bc933 Johannes Berg    2011-01-18  2241   * @max_tx_aggregation_subframes: maximum number of subframes in an
41cbb0f5a2 Luca Coelho      2018-06-09  2242   *	aggregate an HT/HE device will transmit. In HT AddBA we'll
41cbb0f5a2 Luca Coelho      2018-06-09  2243   *	advertise a constant value of 64 as some older APs crash if
41cbb0f5a2 Luca Coelho      2018-06-09  2244   *	the window size is smaller (an example is LinkSys WRT120N
41cbb0f5a2 Luca Coelho      2018-06-09  2245   *	with FW v1.0.07 build 002 Jun 18 2012).
41cbb0f5a2 Luca Coelho      2018-06-09  2246   *	For AddBA to HE capable peers this value will be used.
3a25a8c8b7 Johannes Berg    2012-04-03  2247   *
6e0456b545 Felix Fietkau    2016-03-03  2248   * @max_tx_fragments: maximum number of tx buffers per (A)-MSDU, sum
6e0456b545 Felix Fietkau    2016-03-03  2249   *	of 1 + skb_shinfo(skb)->nr_frags for each skb in the frag_list.
6e0456b545 Felix Fietkau    2016-03-03  2250   *
3a25a8c8b7 Johannes Berg    2012-04-03  2251   * @offchannel_tx_hw_queue: HW queue ID to use for offchannel TX
3a25a8c8b7 Johannes Berg    2012-04-03  2252   *	(if %IEEE80211_HW_QUEUE_CONTROL is set)
ac55d2fe05 Johannes Berg    2012-05-10  2253   *
ac55d2fe05 Johannes Berg    2012-05-10  2254   * @radiotap_mcs_details: lists which MCS information can the HW
ac55d2fe05 Johannes Berg    2012-05-10  2255   *	reports, by default it is set to _MCS, _GI and _BW but doesn't
b4f7f4ad42 Jani Nikula      2016-10-21  2256   *	include _FMT. Use %IEEE80211_RADIOTAP_MCS_HAVE_\* values, only
ac55d2fe05 Johannes Berg    2012-05-10  2257   *	adding _BW is supported today.
72d7872852 Arik Nemtsov     2012-05-10  2258   *
5164892184 Johannes Berg    2012-11-22  2259   * @radiotap_vht_details: lists which VHT MCS information the HW reports,
5164892184 Johannes Berg    2012-11-22  2260   *	the default is _GI | _BANDWIDTH.
b4f7f4ad42 Jani Nikula      2016-10-21  2261   *	Use the %IEEE80211_RADIOTAP_VHT_KNOWN_\* values.
5164892184 Johannes Berg    2012-11-22  2262   *
41cbb0f5a2 Luca Coelho      2018-06-09  2263   * @radiotap_he: HE radiotap validity flags
41cbb0f5a2 Luca Coelho      2018-06-09  2264   *
99ee7cae3b Johannes Berg    2016-08-29  2265   * @radiotap_timestamp: Information for the radiotap timestamp field; if the
99ee7cae3b Johannes Berg    2016-08-29  2266   *	'units_pos' member is set to a non-negative value it must be set to
99ee7cae3b Johannes Berg    2016-08-29  2267   *	a combination of a IEEE80211_RADIOTAP_TIMESTAMP_UNIT_* and a
99ee7cae3b Johannes Berg    2016-08-29  2268   *	IEEE80211_RADIOTAP_TIMESTAMP_SPOS_* value, and then the timestamp
99ee7cae3b Johannes Berg    2016-08-29  2269   *	field will be added and populated from the &struct ieee80211_rx_status
99ee7cae3b Johannes Berg    2016-08-29  2270   *	device_timestamp. If the 'accuracy' member is non-negative, it's put
99ee7cae3b Johannes Berg    2016-08-29  2271   *	into the accuracy radiotap field and the accuracy known flag is set.
99ee7cae3b Johannes Berg    2016-08-29  2272   *
72d7872852 Arik Nemtsov     2012-05-10  2273   * @netdev_features: netdev features to be set in each netdev created
680a0daba7 Johannes Berg    2015-04-13  2274   *	from this HW. Note that not all features are usable with mac80211,
680a0daba7 Johannes Berg    2015-04-13  2275   *	other features will be rejected during HW registration.
219c38674c Alexander Bondar 2013-01-22  2276   *
219c38674c Alexander Bondar 2013-01-22  2277   * @uapsd_queues: This bitmap is included in (re)association frame to indicate
219c38674c Alexander Bondar 2013-01-22  2278   *	for each access category if it is uAPSD trigger-enabled and delivery-
219c38674c Alexander Bondar 2013-01-22  2279   *	enabled. Use IEEE80211_WMM_IE_STA_QOSINFO_AC_* to set this bitmap.
219c38674c Alexander Bondar 2013-01-22  2280   *	Each bit corresponds to different AC. Value '1' in specific bit means
219c38674c Alexander Bondar 2013-01-22  2281   *	that corresponding AC is both trigger- and delivery-enabled. '0' means
219c38674c Alexander Bondar 2013-01-22  2282   *	neither enabled.
219c38674c Alexander Bondar 2013-01-22  2283   *
219c38674c Alexander Bondar 2013-01-22  2284   * @uapsd_max_sp_len: maximum number of total buffered frames the WMM AP may
219c38674c Alexander Bondar 2013-01-22  2285   *	deliver to a WMM STA during any Service Period triggered by the WMM STA.
219c38674c Alexander Bondar 2013-01-22  2286   *	Use IEEE80211_WMM_IE_STA_QOSINFO_SP_* for correct values.
2475b1cc0d Max Stepanov     2013-03-24  2287   *
2475b1cc0d Max Stepanov     2013-03-24  2288   * @n_cipher_schemes: a size of an array of cipher schemes definitions.
2475b1cc0d Max Stepanov     2013-03-24  2289   * @cipher_schemes: a pointer to an array of cipher scheme definitions
2475b1cc0d Max Stepanov     2013-03-24  2290   *	supported by HW.
167e33f4f6 Ayala Beker      2016-09-20  2291   * @max_nan_de_entries: maximum number of NAN DE functions supported by the
167e33f4f6 Ayala Beker      2016-09-20  2292   *	device.
7ac1bd6aec Johannes Berg    2007-09-14  2293   */
f0706e828e Jiri Benc        2007-05-05  2294  struct ieee80211_hw {
f0706e828e Jiri Benc        2007-05-05  2295  	struct ieee80211_conf conf;
75a5f0ccfd Johannes Berg    2007-09-18  2296  	struct wiphy *wiphy;
830f903866 Johannes Berg    2007-10-28  2297  	const char *rate_control_algorithm;
f0706e828e Jiri Benc        2007-05-05  2298  	void *priv;
30686bf7f5 Johannes Berg    2015-06-02  2299  	unsigned long flags[BITS_TO_LONGS(NUM_IEEE80211_HW_FLAGS)];
f0706e828e Jiri Benc        2007-05-05  2300  	unsigned int extra_tx_headroom;
70dabeb74e Felix Fietkau    2013-12-14  2301  	unsigned int extra_beacon_tailroom;
32bfd35d4b Johannes Berg    2007-12-19  2302  	int vif_data_size;
17741cdc26 Johannes Berg    2008-09-11  2303  	int sta_data_size;
d01a1e6586 Michal Kazior    2012-06-26  2304  	int chanctx_data_size;
ba8c3d6f16 Felix Fietkau    2015-03-27  2305  	int txq_data_size;
ea95bba41e Tomas Winkler    2008-07-18  2306  	u16 queues;
ea95bba41e Tomas Winkler    2008-07-18  2307  	u16 max_listen_interval;
f0706e828e Jiri Benc        2007-05-05  2308  	s8 max_signal;
e6a9854b05 Johannes Berg    2008-10-21  2309  	u8 max_rates;
78be49ec2a Helmut Schaa     2010-10-02  2310  	u8 max_report_rates;
e6a9854b05 Johannes Berg    2008-10-21  2311  	u8 max_rate_tries;
41cbb0f5a2 Luca Coelho      2018-06-09  2312  	u16 max_rx_aggregation_subframes;
41cbb0f5a2 Luca Coelho      2018-06-09  2313  	u16 max_tx_aggregation_subframes;
6e0456b545 Felix Fietkau    2016-03-03  2314  	u8 max_tx_fragments;
3a25a8c8b7 Johannes Berg    2012-04-03  2315  	u8 offchannel_tx_hw_queue;
ac55d2fe05 Johannes Berg    2012-05-10  2316  	u8 radiotap_mcs_details;
5164892184 Johannes Berg    2012-11-22  2317  	u16 radiotap_vht_details;
99ee7cae3b Johannes Berg    2016-08-29  2318  	struct {
99ee7cae3b Johannes Berg    2016-08-29  2319  		int units_pos;
99ee7cae3b Johannes Berg    2016-08-29  2320  		s16 accuracy;
99ee7cae3b Johannes Berg    2016-08-29  2321  	} radiotap_timestamp;
72d7872852 Arik Nemtsov     2012-05-10  2322  	netdev_features_t netdev_features;
219c38674c Alexander Bondar 2013-01-22  2323  	u8 uapsd_queues;
219c38674c Alexander Bondar 2013-01-22  2324  	u8 uapsd_max_sp_len;
2475b1cc0d Max Stepanov     2013-03-24  2325  	u8 n_cipher_schemes;
2475b1cc0d Max Stepanov     2013-03-24  2326  	const struct ieee80211_cipher_scheme *cipher_schemes;
167e33f4f6 Ayala Beker      2016-09-20  2327  	u8 max_nan_de_entries;
c03233ae8c Wen Gong         2018-07-26  2328  	u8 tx_sk_pacing_shift;
f0706e828e Jiri Benc        2007-05-05 @2329  };
f0706e828e Jiri Benc        2007-05-05  2330  

:::::: The code at line 2329 was first introduced by commit
:::::: f0706e828e96d0fa4e80c0d25aa98523f6d589a0 [MAC80211]: Add mac80211 wireless stack.

:::::: TO: Jiri Benc <jbenc@suse.cz>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--WIyZ46R2i8wDzkSu
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
vQEfM5zExfsPx4noZ+pZAAA=

--WIyZ46R2i8wDzkSu--
