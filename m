Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:17998 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752709AbeEGV5p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 17:57:45 -0400
Date: Tue, 8 May 2018 05:56:54 +0800
From: kbuild test robot <lkp@intel.com>
To: Balaji Pothunoori <bpothuno@codeaurora.org>
Cc: kbuild-all@01.org, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [mac80211-next:master 11/11] htmldocs: net/mac80211/sta_info.h:588:
 warning: Function parameter or member 'status_stats.avg_ack_signal' not
 described in 'sta_info'
Message-ID: <201805080548.zGL2YrI3%fengguang.wu@intel.com> (sfid-20180507_235749_515121_89144AA9)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
head:   cc60dbbfed8ff0bd4c530ee48e9e915333a35470
commit: cc60dbbfed8ff0bd4c530ee48e9e915333a35470 [11/11] mac80211: average ack rssi support for data frames
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   include/net/mac80211.h:955: warning: Function parameter or member 'control.skip_table' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:955: warning: Function parameter or member 'control.jiffies' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:955: warning: Function parameter or member 'control.vif' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:955: warning: Function parameter or member 'control.hw_key' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:955: warning: Function parameter or member 'control.flags' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:955: warning: Function parameter or member 'control.enqueue_time' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:955: warning: Function parameter or member 'ack' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:955: warning: Function parameter or member 'ack.cookie' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:955: warning: Function parameter or member 'status.rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:955: warning: Function parameter or member 'status.ack_signal' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:955: warning: Function parameter or member 'status.ampdu_ack_len' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:955: warning: Function parameter or member 'status.ampdu_len' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:955: warning: Function parameter or member 'status.antenna' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:955: warning: Function parameter or member 'status.tx_time' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:955: warning: Function parameter or member 'status.is_valid_ack_signal' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:955: warning: Function parameter or member 'status.status_driver_data' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:955: warning: Function parameter or member 'driver_rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:955: warning: Function parameter or member 'pad' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:955: warning: Function parameter or member 'rate_driver_data' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
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
>> net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.avg_ack_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'tx_stats.packets' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'tx_stats.bytes' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'tx_stats.last_rate' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'tx_stats.msdu' not described in 'sta_info'
   kernel/sched/fair.c:3731: warning: Function parameter or member 'flags' not described in 'attach_entity_load_avg'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_excl.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_excl.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_excl.active' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_shared.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_shared.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_shared.active' not described in 'dma_buf'
   include/linux/dma-fence-array.h:54: warning: Function parameter or member 'work' not described in 'dma_fence_array'
   Error: Cannot open file drivers/base/firmware_class.c
   WARNING: kernel-doc 'scripts/kernel-doc -rst -enable-lineno -function request_firmware drivers/base/firmware_class.c' failed with return code 1
   Error: Cannot open file drivers/base/firmware_class.c
   WARNING: kernel-doc 'scripts/kernel-doc -rst -enable-lineno -function request_firmware_direct drivers/base/firmware_class.c' failed with return code 1
   Error: Cannot open file drivers/base/firmware_class.c
   WARNING: kernel-doc 'scripts/kernel-doc -rst -enable-lineno -function request_firmware_into_buf drivers/base/firmware_class.c' failed with return code 1
   Error: Cannot open file drivers/base/firmware_class.c
   WARNING: kernel-doc 'scripts/kernel-doc -rst -enable-lineno -function request_firmware_nowait drivers/base/firmware_class.c' failed with return code 1
   Error: Cannot open file drivers/base/firmware_class.c
   WARNING: kernel-doc 'scripts/kernel-doc -rst -enable-lineno -function firmware_request_cache drivers/base/firmware_class.c' failed with return code 1
   include/linux/gpio/driver.h:142: warning: Function parameter or member 'request_key' not described in 'gpio_irq_chip'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.sign' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.realbits' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.storagebits' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.shift' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.repeat' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.endianness' not described in 'iio_chan_spec'
   include/linux/iio/hw-consumer.h:1: warning: no structured comments found
   Error: Cannot open file drivers/base/firmware_class.c
   Error: Cannot open file drivers/base/firmware_class.c
   WARNING: kernel-doc 'scripts/kernel-doc -rst -enable-lineno -export drivers/base/firmware_class.c' failed with return code 2
   include/linux/input/sparse-keymap.h:46: warning: Function parameter or member 'sw' not described in 'key_entry'
   include/linux/mtd/rawnand.h:752: warning: Function parameter or member 'timings.sdr' not described in 'nand_data_interface'
   include/linux/mtd/rawnand.h:817: warning: Function parameter or member 'buf' not described in 'nand_op_data_instr'
   include/linux/mtd/rawnand.h:817: warning: Function parameter or member 'buf.in' not described in 'nand_op_data_instr'
   include/linux/mtd/rawnand.h:817: warning: Function parameter or member 'buf.out' not described in 'nand_op_data_instr'
   include/linux/mtd/rawnand.h:863: warning: Function parameter or member 'ctx' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:863: warning: Function parameter or member 'ctx.cmd' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:863: warning: Function parameter or member 'ctx.addr' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:863: warning: Function parameter or member 'ctx.data' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:863: warning: Function parameter or member 'ctx.waitrdy' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:1010: warning: Function parameter or member 'ctx' not described in 'nand_op_parser_pattern_elem'
   include/linux/mtd/rawnand.h:1010: warning: Function parameter or member 'ctx.addr' not described in 'nand_op_parser_pattern_elem'
   include/linux/mtd/rawnand.h:1010: warning: Function parameter or member 'ctx.data' not described in 'nand_op_parser_pattern_elem'
   include/linux/mtd/rawnand.h:1313: warning: Function parameter or member 'manufacturer.desc' not described in 'nand_chip'
   include/linux/mtd/rawnand.h:1313: warning: Function parameter or member 'manufacturer.priv' not described in 'nand_chip'
   include/linux/regulator/driver.h:222: warning: Function parameter or member 'resume_early' not described in 'regulator_ops'
   drivers/regulator/core.c:4306: warning: Excess function parameter 'state' description in 'regulator_suspend_late'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw0' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw1' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw2' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw3' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.eadm' not described in 'irb'
   drivers/usb/typec/mux.c:186: warning: Function parameter or member 'mux' not described in 'typec_mux_unregister'
   drivers/usb/typec/mux.c:186: warning: Excess function parameter 'sw' description in 'typec_mux_unregister'

vim +588 net/mac80211/sta_info.h

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
0fabfaafe Arik Nemtsov           2015-06-10  585  
17741cdc2 Johannes Berg          2008-09-11  586  	/* keep last! */
17741cdc2 Johannes Berg          2008-09-11  587  	struct ieee80211_sta sta;
f0706e828 Jiri Benc              2007-05-05 @588  };
f0706e828 Jiri Benc              2007-05-05  589  

:::::: The code at line 588 was first introduced by commit
:::::: f0706e828e96d0fa4e80c0d25aa98523f6d589a0 [MAC80211]: Add mac80211 wireless stack.

:::::: TO: Jiri Benc <jbenc@suse.cz>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--FL5UXtIhxfXey3p5
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--FL5UXtIhxfXey3p5--
