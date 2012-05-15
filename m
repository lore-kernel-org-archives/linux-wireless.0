Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1738 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758421Ab2EOIxj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 04:53:39 -0400
Message-ID: <4FB21985.9090306@broadcom.com> (sfid-20120515_105351_243511_1FD1B251)
Date: Tue, 15 May 2012 10:53:25 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "F. LECAILLE" <flc@netgem.com>
cc: linux-wireless@vger.kernel.org
Subject: Re: broadcom 43236B USB module
References: <4FB2033B.4070701@netgem.com>
In-Reply-To: <4FB2033B.4070701@netgem.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/15/2012 09:18 AM, F. LECAILLE wrote:
> Hello,
> 
> I have some Wifi USB modules with 43236B Broadcom chipset. I have read on the
> linuxwireless dot org website that this chipset is supported by the brcmfmac
> *(USB)* driver.
> 
> As I am also trying to backport this driver for an embedded device which runs a
> 2.6.27 kernel, I had a look to the 3.2 kernel sources and especially to the
> drivers/net/wireless/brcm80211/brcmfmac directory. But I do not find any
> reference to USB stack kernel functions.
> 
> How may this work?

It works by being patient. USB support was merged upstream in the
previous merge window so it is present in the current 3.4-rcX releases.
If you want to backport I suggest to use compat-wireless (see [1]) as it
does a lot of work for you.

Gr. AvS

[1] http://linuxwireless.org/en/users/Download

