Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:33844 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752637AbZBBQG3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 11:06:29 -0500
Message-ID: <498719F3.4070601@lwfinger.net> (sfid-20090202_170633_667259_3CB478C0)
Date: Mon, 02 Feb 2009 10:06:11 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hans Ekbrand <hans@sociologi.cjb.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: USB 1.1, usb-dongle, NETGEAR WG111v2, timing problems in	association
References: <20090117204654.GB9079@amin> <4972B25B.7070306@lwfinger.net> <20090202155542.GE24485@samir>
In-Reply-To: <20090202155542.GE24485@samir>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hans Ekbrand wrote:
> On Sat, Jan 17, 2009 at 10:38:51PM -0600, Larry Finger wrote:
>> Hans Ekbrand wrote:
>>> Hi list!
>>>
>>> On an old system with only USB 1.1, I tried to use a USB-dongle:
>>> NETGEAR WG111v2. The device works perfectly with same kernel (2.6.26-1
>>> from debian lenny) on a new system with USB 2.0, using the "rtl8187"
>>> driver.
>>>
>>> However, on USB 1.1 I get:
>> I just bought a WG111v2 on E-Bay last week. Once it arrives, I will be
>> able to test the performance of this device.
> 
> Have you had the possiblity to try it on USB 1.1 yet?

Yes and it works.

Once I got the device, I found and fixed two main problems in the
driver for the RTL8187. The first keeps mac80211 from adjusting the
wireless rate, and the second hurts the power setting for OFDM rates.
Both of these are fixed in the latest wireless-testing and in
compat-wireless.

Larry
