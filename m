Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr8.hinet.net ([168.95.4.108]:41134 "EHLO msr8.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab1HKCSI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 22:18:08 -0400
Date: Thu, 11 Aug 2011 10:15:54 +0800
From: Ali Bahar <ali@internetdog.org>
To: Pedram Navid <pedram.navid@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: brcmsmac: fifo 0: descriptor error
Message-ID: <20110811021554.GA24567@internetdog.org> (sfid-20110811_041815_592340_44BDCCAE)
Reply-To: ali@internetdog.org
References: <6264DDFA6754194CAB6452BFF5202C330F5F2115@SXGM-401.fg.rbc.com>
 <CAPoLzpe0OYq677NooOY5F7PyvbNobOXXCuSnoaF7ZVc0cJkjAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAPoLzpe0OYq677NooOY5F7PyvbNobOXXCuSnoaF7ZVc0cJkjAw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pedram,

you must use a meaningful Subject-line for your email.
Hopefully, this'll attract the attention of the couple of Broadcom guys
who are on this list.

Also,


On Wed, Aug 10, 2011 at 06:48:45PM -0400, Pedram Navid wrote:
> Hello,
> 
> I'd like to report a bug I have not been able to find elsewhere. I am on
> a fresh Arch install with linux 3.0.1-1, using the brcmsmac module.
> Initially, the wireless works for a few days. At some point, it will
> stop, outputing the following error repeatedly:
> 
> Aug  7 09:55:27 localhost kernel: [  825.796697] ieee80211 phy0: wl0:
> fifo 0: descriptor error
> Aug  7 09:55:27 localhost kernel: [  825.796713] ieee80211 phy0: wl0:
> fatal error, re-initializing

You may wish to note which of these lines repeat. Do both repeat, or
only the "re-initializing" line? (It may be easier to just paste a few
lines into your mail.)

later,
ali

 
> I can rmmod brcmsmac, reboot, shutdown, give it a few days, and start
> over and it will sometimes work. Other times, it will persist with the
> fifo errors. Please let me know you need additional log files. I had
> this problem since 2.6.38 and reinstalled Arch twice, thinking it was
> something with my setup that was done incorrectly but haven't been
> able to figure it out. I can't find another case of this error on the
> internet.
> 
> #    lspci -vnn | grep 14e4
> 05:00.0 Network controller [0280]: Broadcom Corporation
> 802.11b/g/n Wireless LAN Controller [14e4:4727] (rev 01)
>        Subsystem: Broadcom Corporation Device [14e4:0510]
> 
>  #  lsmod  | grep brc
> brcmsmac              594624  0
> brcmutil                6563  1 brcmsmac
> mac80211              215605  1 brcmsmac
> cfg80211              160516  2 brcmsmac,mac80211
> crc_ccitt               1331  1 brcmsmac
> 
> Thank you
> Pedram
