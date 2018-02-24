Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:40335 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751364AbeBXQDW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Feb 2018 11:03:22 -0500
Date: Sun, 25 Feb 2018 00:02:58 +0800
From: kbuild test robot <lkp@intel.com>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: kbuild-all@01.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: Re: [PATCHv3 3/3] mac80211: implement cqm rssi check using rx data
 signal
Message-ID: <201802242350.uzDyyiUK%fengguang.wu@intel.com> (sfid-20180224_170339_028426_CA408929)
References: <1519285340-5463-4-git-send-email-tamizhr@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TB36FDmn/VVEgNH/"
In-Reply-To: <1519285340-5463-4-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Tamizh,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mac80211-next/master]
[also build test WARNING on next-20180223]
[cannot apply to v4.16-rc2]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Tamizh-chelvam/cfg80211-mac80211-cqm-rssi-config-for-AP-mode/20180224-194110
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   WARNING: convert(1) not found, for SVG to PDF conversion install ImageMagick (https://www.imagemagick.org)
   include/linux/crypto.h:477: warning: Function parameter or member 'cra_u.ablkcipher' not described in 'crypto_alg'
   include/linux/crypto.h:477: warning: Function parameter or member 'cra_u.blkcipher' not described in 'crypto_alg'
   include/linux/crypto.h:477: warning: Function parameter or member 'cra_u.cipher' not described in 'crypto_alg'
   include/linux/crypto.h:477: warning: Function parameter or member 'cra_u.compress' not described in 'crypto_alg'
   include/net/cfg80211.h:4197: warning: Function parameter or member 'wext.ibss' not described in 'wireless_dev'
   include/net/cfg80211.h:4197: warning: Function parameter or member 'wext.connect' not described in 'wireless_dev'
   include/net/cfg80211.h:4197: warning: Function parameter or member 'wext.keys' not described in 'wireless_dev'
   include/net/cfg80211.h:4197: warning: Function parameter or member 'wext.ie' not described in 'wireless_dev'
   include/net/cfg80211.h:4197: warning: Function parameter or member 'wext.ie_len' not described in 'wireless_dev'
   include/net/cfg80211.h:4197: warning: Function parameter or member 'wext.bssid' not described in 'wireless_dev'
   include/net/cfg80211.h:4197: warning: Function parameter or member 'wext.prev_bssid' not described in 'wireless_dev'
   include/net/cfg80211.h:4197: warning: Function parameter or member 'wext.ssid' not described in 'wireless_dev'
   include/net/cfg80211.h:4197: warning: Function parameter or member 'wext.default_key' not described in 'wireless_dev'
   include/net/cfg80211.h:4197: warning: Function parameter or member 'wext.default_mgmt_key' not described in 'wireless_dev'
   include/net/cfg80211.h:4197: warning: Function parameter or member 'wext.prev_bssid_valid' not described in 'wireless_dev'
   include/net/mac80211.h:2282: warning: Function parameter or member 'radiotap_timestamp.units_pos' not described in 'ieee80211_hw'
   include/net/mac80211.h:2282: warning: Function parameter or member 'radiotap_timestamp.accuracy' not described in 'ieee80211_hw'
   include/net/mac80211.h:959: warning: Function parameter or member 'rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:959: warning: Function parameter or member 'control.rts_cts_rate_idx' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:959: warning: Function parameter or member 'control.use_rts' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:959: warning: Function parameter or member 'control.use_cts_prot' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:959: warning: Function parameter or member 'control.short_preamble' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:959: warning: Function parameter or member 'control.skip_table' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:959: warning: Function parameter or member 'control.jiffies' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:959: warning: Function parameter or member 'control.vif' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:959: warning: Function parameter or member 'control.hw_key' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:959: warning: Function parameter or member 'control.flags' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:959: warning: Function parameter or member 'control.enqueue_time' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:959: warning: Function parameter or member 'ack' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:959: warning: Function parameter or member 'ack.cookie' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:959: warning: Function parameter or member 'status.rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:959: warning: Function parameter or member 'status.ack_signal' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:959: warning: Function parameter or member 'status.ampdu_ack_len' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:959: warning: Function parameter or member 'status.ampdu_len' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:959: warning: Function parameter or member 'status.antenna' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:959: warning: Function parameter or member 'status.tx_time' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:959: warning: Function parameter or member 'status.is_valid_ack_signal' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:959: warning: Function parameter or member 'status_driver_data' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:959: warning: Function parameter or member 'driver_rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:959: warning: Function parameter or member 'pad' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:959: warning: Function parameter or member 'rate_driver_data' not described in 'ieee80211_tx_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'rx_stats_avg' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'rx_stats_avg.signal' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'rx_stats_avg.chain_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'status_stats.filtered' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'status_stats.retry_failed' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'status_stats.retry_count' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'status_stats.lost_packets' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'status_stats.last_tdls_pkt_time' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'msdu_retries' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'msdu_failed' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'status_stats.last_ack' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'status_stats.last_ack_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'status_stats.ack_signal_filled' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'tx_stats.packets' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'tx_stats.bytes' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'tx_stats.last_rate' not described in 'sta_info'
   net/mac80211/sta_info.h:589: warning: Function parameter or member 'msdu' not described in 'sta_info'
>> net/mac80211/sta_info.h:589: warning: Function parameter or member 'last_cqm_event_signal' not described in 'sta_info'
>> net/mac80211/sta_info.h:589: warning: Function parameter or member 'count_rx_signal' not described in 'sta_info'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_excl.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_excl.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_excl.active' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_shared.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_shared.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_shared.active' not described in 'dma_buf'
   include/linux/dma-fence-array.h:54: warning: Function parameter or member 'work' not described in 'dma_fence_array'
   include/linux/gpio/driver.h:142: warning: Function parameter or member 'request_key' not described in 'gpio_irq_chip'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.sign' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.realbits' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.storagebits' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.shift' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.repeat' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.endianness' not described in 'iio_chan_spec'
   include/linux/iio/hw-consumer.h:1: warning: no structured comments found
   include/linux/device.h:294: warning: Function parameter or member 'coredump' not described in 'device_driver'
   include/linux/input/sparse-keymap.h:46: warning: Function parameter or member 'sw' not described in 'key_entry'
   include/linux/mtd/rawnand.h:709: warning: Function parameter or member 'timings.sdr' not described in 'nand_data_interface'
   include/linux/mtd/rawnand.h:774: warning: Function parameter or member 'buf' not described in 'nand_op_data_instr'
   include/linux/mtd/rawnand.h:774: warning: Function parameter or member 'buf.in' not described in 'nand_op_data_instr'
   include/linux/mtd/rawnand.h:774: warning: Function parameter or member 'buf.out' not described in 'nand_op_data_instr'
   include/linux/mtd/rawnand.h:820: warning: Function parameter or member 'ctx' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:820: warning: Function parameter or member 'ctx.cmd' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:820: warning: Function parameter or member 'ctx.addr' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:820: warning: Function parameter or member 'ctx.data' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:820: warning: Function parameter or member 'ctx.waitrdy' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:967: warning: Function parameter or member 'ctx' not described in 'nand_op_parser_pattern_elem'
   include/linux/mtd/rawnand.h:967: warning: Function parameter or member 'ctx.addr' not described in 'nand_op_parser_pattern_elem'
   include/linux/mtd/rawnand.h:967: warning: Function parameter or member 'ctx.data' not described in 'nand_op_parser_pattern_elem'
   include/linux/mtd/rawnand.h:1281: warning: Function parameter or member 'manufacturer.desc' not described in 'nand_chip'
   include/linux/mtd/rawnand.h:1281: warning: Function parameter or member 'manufacturer.priv' not described in 'nand_chip'
   include/linux/regulator/driver.h:221: warning: Function parameter or member 'resume_early' not described in 'regulator_ops'
   drivers/regulator/core.c:4299: warning: Excess function parameter 'state' description in 'regulator_suspend_late'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw0' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw1' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw2' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw3' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.eadm' not described in 'irb'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_pin' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_unpin' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_res_obj' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_get_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_import_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_vmap' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_vunmap' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_mmap' not described in 'drm_driver'
   include/drm/drm_connector.h:370: warning: Function parameter or member 'margins.left' not described in 'drm_tv_connector_state'
   include/drm/drm_connector.h:370: warning: Function parameter or member 'margins.right' not described in 'drm_tv_connector_state'
   include/drm/drm_connector.h:370: warning: Function parameter or member 'margins.top' not described in 'drm_tv_connector_state'
   include/drm/drm_connector.h:370: warning: Function parameter or member 'margins.bottom' not described in 'drm_tv_connector_state'
   include/drm/drm_vblank.h:63: warning: Function parameter or member 'event.base' not described in 'drm_pending_vblank_event'
   include/drm/drm_vblank.h:63: warning: Function parameter or member 'event.vbl' not described in 'drm_pending_vblank_event'
   include/drm/drm_vblank.h:63: warning: Function parameter or member 'event.seq' not described in 'drm_pending_vblank_event'
   drivers/gpu/drm/tve200/tve200_drv.c:1: warning: no structured comments found
   include/linux/skbuff.h:849: warning: Function parameter or member 'dev_scratch' not described in 'sk_buff'
   include/linux/skbuff.h:849: warning: Function parameter or member 'skb_mstamp' not described in 'sk_buff'
   include/linux/skbuff.h:849: warning: Function parameter or member '__cloned_offset' not described in 'sk_buff'
   include/linux/skbuff.h:849: warning: Function parameter or member 'head_frag' not described in 'sk_buff'
   include/linux/skbuff.h:849: warning: Function parameter or member '__unused' not described in 'sk_buff'
   include/linux/skbuff.h:849: warning: Function parameter or member '__pkt_type_offset' not described in 'sk_buff'
   include/linux/skbuff.h:849: warning: Function parameter or member 'pfmemalloc' not described in 'sk_buff'
   include/linux/skbuff.h:849: warning: Function parameter or member 'encapsulation' not described in 'sk_buff'
   include/linux/skbuff.h:849: warning: Function parameter or member 'encap_hdr_csum' not described in 'sk_buff'
   include/linux/skbuff.h:849: warning: Function parameter or member 'csum_valid' not described in 'sk_buff'
   include/linux/skbuff.h:849: warning: Function parameter or member 'csum_complete_sw' not described in 'sk_buff'
   include/linux/skbuff.h:849: warning: Function parameter or member 'csum_level' not described in 'sk_buff'
   include/linux/skbuff.h:849: warning: Function parameter or member 'inner_protocol_type' not described in 'sk_buff'
   include/linux/skbuff.h:849: warning: Function parameter or member 'remcsum_offload' not described in 'sk_buff'
   include/linux/skbuff.h:849: warning: Function parameter or member 'offload_fwd_mark' not described in 'sk_buff'
   include/linux/skbuff.h:849: warning: Function parameter or member 'offload_mr_fwd_mark' not described in 'sk_buff'
   include/linux/skbuff.h:849: warning: Function parameter or member 'sender_cpu' not described in 'sk_buff'
   include/linux/skbuff.h:849: warning: Function parameter or member 'reserved_tailroom' not described in 'sk_buff'
   include/linux/skbuff.h:849: warning: Function parameter or member 'inner_ipproto' not described in 'sk_buff'
   include/net/sock.h:234: warning: Function parameter or member 'skc_addrpair' not described in 'sock_common'
   include/net/sock.h:234: warning: Function parameter or member 'skc_portpair' not described in 'sock_common'
   include/net/sock.h:234: warning: Function parameter or member 'skc_ipv6only' not described in 'sock_common'
   include/net/sock.h:234: warning: Function parameter or member 'skc_net_refcnt' not described in 'sock_common'
   include/net/sock.h:234: warning: Function parameter or member 'skc_v6_daddr' not described in 'sock_common'
   include/net/sock.h:234: warning: Function parameter or member 'skc_v6_rcv_saddr' not described in 'sock_common'
   include/net/sock.h:234: warning: Function parameter or member 'skc_cookie' not described in 'sock_common'
   include/net/sock.h:234: warning: Function parameter or member 'skc_listener' not described in 'sock_common'
   include/net/sock.h:234: warning: Function parameter or member 'skc_tw_dr' not described in 'sock_common'
   include/net/sock.h:234: warning: Function parameter or member 'skc_rcv_wnd' not described in 'sock_common'
   include/net/sock.h:234: warning: Function parameter or member 'skc_tw_rcv_nxt' not described in 'sock_common'
   include/net/sock.h:488: warning: Function parameter or member 'sk_backlog.rmem_alloc' not described in 'sock'
   include/net/sock.h:488: warning: Function parameter or member 'sk_backlog.len' not described in 'sock'
   include/net/sock.h:488: warning: Function parameter or member 'sk_backlog.head' not described in 'sock'
   include/net/sock.h:488: warning: Function parameter or member 'sk_backlog.tail' not described in 'sock'
   include/net/sock.h:488: warning: Function parameter or member 'sk_wq_raw' not described in 'sock'
   include/net/sock.h:488: warning: Function parameter or member 'tcp_rtx_queue' not described in 'sock'
   include/net/sock.h:488: warning: Function parameter or member 'sk_route_forced_caps' not described in 'sock'
   include/linux/netdevice.h:1946: warning: Function parameter or member 'adj_list.upper' not described in 'net_device'
   include/linux/netdevice.h:1946: warning: Function parameter or member 'adj_list.lower' not described in 'net_device'
   include/linux/netdevice.h:1946: warning: Function parameter or member 'gso_partial_features' not described in 'net_device'
   include/linux/netdevice.h:1946: warning: Function parameter or member 'switchdev_ops' not described in 'net_device'
   include/linux/netdevice.h:1946: warning: Function parameter or member 'l3mdev_ops' not described in 'net_device'
   include/linux/netdevice.h:1946: warning: Function parameter or member 'xfrmdev_ops' not described in 'net_device'
   include/linux/netdevice.h:1946: warning: Function parameter or member 'name_assign_type' not described in 'net_device'
   include/linux/netdevice.h:1946: warning: Function parameter or member 'ieee802154_ptr' not described in 'net_device'
   include/linux/netdevice.h:1946: warning: Function parameter or member 'mpls_ptr' not described in 'net_device'

vim +589 net/mac80211/sta_info.h

17741cdc2 Johannes Berg          2008-09-11  572  
0af83d3df Johannes Berg          2012-12-27  573  	enum ieee80211_sta_rx_bandwidth cur_max_bandwidth;
0af83d3df Johannes Berg          2012-12-27  574  
687da1322 Emmanuel Grumbach      2013-10-01  575  	enum ieee80211_smps_mode known_smps_mode;
2475b1cc0 Max Stepanov           2013-03-24  576  	const struct ieee80211_cipher_scheme *cipher_scheme;
687da1322 Emmanuel Grumbach      2013-10-01  577  
484a54c2e Toke Høiland-Jørgensen 2017-04-06  578  	struct codel_params cparams;
484a54c2e Toke Høiland-Jørgensen 2017-04-06  579  
b6da911b3 Liad Kaufman           2014-11-19  580  	u8 reserved_tid;
b6da911b3 Liad Kaufman           2014-11-19  581  
0fabfaafe Arik Nemtsov           2015-06-10  582  	struct cfg80211_chan_def tdls_chandef;
0fabfaafe Arik Nemtsov           2015-06-10  583  
53536df13 Tamizh chelvam         2018-02-22  584  	int last_cqm_event_signal;
53536df13 Tamizh chelvam         2018-02-22  585  	unsigned int count_rx_signal;
53536df13 Tamizh chelvam         2018-02-22  586  
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

--TB36FDmn/VVEgNH/
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
jKGEsTk7KiwyAXsRukW7FdfnH7KujO30YQAA

--TB36FDmn/VVEgNH/--
