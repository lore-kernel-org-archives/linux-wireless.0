Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32411 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755475AbZA0RQs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 12:16:48 -0500
Subject: Re: Problems with latest driver and iwl4965
From: reinette chatre <reinette.chatre@intel.com>
To: Thorsten Maus <maus@bercruz.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <497ECAFE.8030900@bercruz.com>
References: <497ECAFE.8030900@bercruz.com>
Content-Type: text/plain
Date: Tue, 27 Jan 2009 09:19:39 -0800
Message-Id: <1233076779.8772.10.camel@rc-desk> (sfid-20090127_181652_329657_98DC4E72)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-01-27 at 00:51 -0800, Thorsten Maus wrote:

> Problem description:
> Directly after starting the device, the internet connection is stable.
> From time to time however the connection for at least the http based
> protocol as well as the protocol used for mail stops working.
> None of the available log-files produce any additional output during
> off-time.

Would it be possible to obtain an over the air as well as a local
tcpdump on your wireless interface capture during this time?

Also, when this problem occurs, could you please enable RX and TX
debugging as follows and then rerun your test:

$ echo 0x41843fff > /sys/class/net/wlan0/device/debug_level

This will generate a lot of information. Would it be possible to send
all kernel messages to a file (edit syslog.conf) temporarily to ensure
we get all information?

Thanks

Reinette



