Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1108 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab3IWIOC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Sep 2013 04:14:02 -0400
Message-ID: <523FF83D.8030103@broadcom.com> (sfid-20130923_101437_670859_332A456A)
Date: Mon, 23 Sep 2013 10:13:49 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Michael Stolovitzsky" <emestee@catnarok.net>,
	linux-wireless@vger.kernel.org,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
Subject: Re: brcmsmac causes soft lockup in 3.12-rc1
References: <20130921223440.GA5297@mail.catnarok.net>
In-Reply-To: <20130921223440.GA5297@mail.catnarok.net>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/22/2013 12:34 AM, Michael Stolovitzsky wrote:
> Hi,
>
> On 3.12-rc1, modprobe brcmsmac causes a soft lockup (trace #1), effectively killing the box. This is a Lenovo S206
> with BCM4313 (14e4:4727), which I believe is a bluetooth combo board. After a while,
> RCU scheduler code detects a lockup (trace #2).
>
> This did not happen in 3.11.1, although brcmsmac hasn't worked on this machine
> as far as I remember. In  the previous kernels (~3.2.0+), it loads, but the
> reception is extremely weak - you must be within few meters to the AP, and the card would
> die after several minutes. The proprietary wl.ko driver works fine.
>
> I've attached the dmesg output, the kernel configuration and the output of lspci -vnn.
> I'm comfortable with experimenting; please let me know how I can help here.

A fix for this problem has been submitted to John. I think it is in 
transit to mainline so probably will be in 3.12-rc2.

Here the URL of the patch:

https://git.kernel.org/cgit/linux/kernel/git/linville/wireless.git/patch/?id=aaa2ced15ad8dca8048666c9f70736424d696a6b

Regards,
Arend

