Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp102.biz.mail.bf1.yahoo.com ([98.139.221.61]:20891 "HELO
	smtp102.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751894Ab3GaR7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 13:59:25 -0400
Message-ID: <51F94EEA.8040503@gespk.com> (sfid-20130731_195928_298047_0C398D03)
Date: Wed, 31 Jul 2013 22:52:42 +0500
From: Abdur Rehman <arqureshi@gespk.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Subject: Intel WiFi Link 4965AGN - Failed, HW not ready
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi we are unable to load the driver for Intel 4965agn module on a linux 
system.
We are seeing "HW not ready" error. Please see the log below

modprobe iwlagn
[ 54.690000] cfg80211: Using static regulatory domain info
[ 54.700000] cfg80211: Regulatory domain: US
[ 54.710000] (start_freq - end_freq @ bandwidth), (max_antenna_gain, 
max_eirp)
[ 54.720000] (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[ 54.730000] (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[ 54.740000] (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[ 54.750000] (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[ 54.760000] (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[ 54.770000] (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[ 54.780000] cfg80211: Calling CRDA for country: US
[ 55.080000] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 
1.3.27k
[ 55.090000] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[ 55.100000] PCI: enabling device 0000:04:00.0 (0000 -> 0002)
[ 55.110000] iwlagn 0000:04:00.0: Detected Intel Wireless WiFi Link 
4965AGN REV=0x0
[ 55.120000] iwlagn 0000:04:00.0: Failed, HW not ready
