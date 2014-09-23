Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:38496 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbaIWQCP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 12:02:15 -0400
Message-ID: <54219984.2080601@msgid.tls.msk.ru> (sfid-20140923_180224_159233_4E75C4CE)
Date: Tue, 23 Sep 2014 20:02:12 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Arend van Spriel <arend@broadcom.com>,
	brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: BCM4313 & brcmsmac & 3.12: only semi-working?
References: <53FDACD1.8090805@msgid.tls.msk.ru> <53FDF8EB.4050905@broadcom.com> <54169D4F.2090607@broadcom.com> <541EEF17.7020806@msgid.tls.msk.ru> <542145B1.4030202@msgid.tls.msk.ru> <54216BF1.3060500@broadcom.com> <20140923134419.GA19016@ubuntu-hedt> <54217AA5.2060803@broadcom.com> <542182BE.2000606@msgid.tls.msk.ru> <542183A6.4070207@msgid.tls.msk.ru> <20140923143124.GC19016@ubuntu-hedt>
In-Reply-To: <20140923143124.GC19016@ubuntu-hedt>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

23.09.2014 18:31, Seth Forshee пишет:
> On Tue, Sep 23, 2014 at 06:28:54PM +0400, Michael Tokarev wrote:
>> 23.09.2014 18:25, Michael Tokarev wrote:
>>> 23.09.2014 17:50, Arend van Spriel wrote:
>>>> On 09/23/14 15:44, Seth Forshee wrote:
>> []
>>>>> It's been quite some time since I used them, but I think brcmsmac_tx is
>>>>> quite noisy so you may only want to enable that if you already suspect a
>>>>> tx problem. I always find it useful to enable the mac80211 and
>>>>> mac80211_msg events too when debugging wireless, and I often enable
>>>>> cfg80211 events as well (none of these are especially verbose).
>>
>> mac80211_msg does not exist, it looks like.  fwiw.
> 
> Did you check your kernel's config? You need to have
> CONFIG_MAC80211_MESSAGE_TRACING enabled.

Oh. Indeed.  While I enabled it, I recompiled only drivers/net/wireless,
but not net/.  Rebuilt, another trace is here --

 http://www.corpit.ru/mjt/tmp/brcmsmac-4313-trace-201409233.dat.gz

Thanks,

/mjt

