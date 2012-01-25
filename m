Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36384 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab2AYViO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jan 2012 16:38:14 -0500
Received: by yenm6 with SMTP id m6so2668290yen.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jan 2012 13:38:13 -0800 (PST)
Message-ID: <4F207641.2090908@lwfinger.net> (sfid-20120125_223817_804592_01D43E18)
Date: Wed, 25 Jan 2012 15:38:09 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Timon ter Braak <timon@terbraak.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: Realtek rtl8192se in AP mode?
References: <CAP6E9idrT=gu6cnKqMzVMVEXqRHdyuADgBNJTdCebt1Rf1dcfg@mail.gmail.com> <jfoo7s$4n9$1@dough.gmane.org>
In-Reply-To: <jfoo7s$4n9$1@dough.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/25/2012 05:15 AM, Timon ter Braak wrote:
> I can confirm this issue. With another chip/device I have an AP running fine for
> years now, but with my new system I have been unsuccessful.
> I have tried a variety of settings, and I am quite confident that it will not
> work until the driver/firmware is fixed.
>
> Realtek just released a new driver, but until now I was unable to download and
> test it (permission denied):
>
> http://www.realtek.com.tw/downloads/downloadsView.aspx?Langid=1&PNid=21&PFid=48&Level=5&Conn=4&ProdID=230&DownTypeID=3&GetDown=false&Downloads=true&SortByDesc=1

The kernel version of rtl8192se is known to fail in AP mode. It is a problem 
that I work on when I get time; however, any difficulty in STA mode has higher 
priority than any in AP mode.

I was able to download the vendor driver from both the USA2 and USA3 mirrors. It 
compiled under kernel 3.3-rc1 with only a few harmless warnings, and should 
build OK for any kernel version. It does work in AP mode.

I am comparing the kernel source with 
"realtek/rtl_92ce_92se_92de_linux_mac80211_0005.1230.2011". Although they 
started from a common point, there has been considerable divergence, thus a 
simple comparison of the two sets of sources is a bit difficult.

If all the Realtek FTP sites fail, please let me know, and I will mail you the 
vendor source. I have not attached it here as it is too big for the ML.

Larry
