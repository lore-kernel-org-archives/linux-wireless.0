Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40922 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756882Ab2CLUsX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 16:48:23 -0400
Message-ID: <4F5E60E2.3080203@hauke-m.de> (sfid-20120312_214828_942659_40F8D789)
Date: Mon, 12 Mar 2012 21:47:30 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Florian Fainelli <florian@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
	linux-mips@linux-mips.org, ralf@linux-mips.org, m@bues.ch,
	linux-usb@vger.kernel.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/7] bcma: scan for extra address space
References: <1331496505-18697-1-git-send-email-hauke@hauke-m.de> <1331496505-18697-4-git-send-email-hauke@hauke-m.de> <CAGRGNgX116dRB03NTL_DFZ4b_PYcdY+Un_cVwt6ZUGR1bwZzHA@mail.gmail.com> <4F5D3679.3090900@hauke-m.de> <CAGRGNgWsO9s2rW1pKBFWd_-0oTAGs9_RXNGyn_y7ic=0Zer=qQ@mail.gmail.com> <20120312174113.GC2778@tuxdriver.com> <4F5E395F.9020603@openwrt.org>
In-Reply-To: <4F5E395F.9020603@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/12/2012 06:58 PM, Florian Fainelli wrote:
> 
> 
> Le 03/12/12 18:41, John W. Linville a écrit :
>> On Mon, Mar 12, 2012 at 12:30:54PM +1100, Julian Calaby wrote:
>>> Hi Hauke,
>>>
>>> On Mon, Mar 12, 2012 at 10:34, Hauke Mehrtens<hauke@hauke-m.de>  wrote:
>>
>>>> I will fix this, should I resend the hole series or just this patch?
>>>
>>> I'm not sure the rest of the series made it to linux-wireless, so
>>> maybe you should resend everything.
>>
>> FWIW, this was the only one I saw...
> 
> For some reasons I received it from linux-mips-bounces using another
> email account, but only patch 3 CC'd linux-wireless.

Sorry for the confusion.
I didn't send all patches to linux-wireless as the others are just
touching usb and mips. The next round will go completely to linux-wireless.

Hauke
