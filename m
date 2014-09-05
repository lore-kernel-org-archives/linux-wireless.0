Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:54211 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756950AbaIEM1Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 08:27:16 -0400
Received: by mail-we0-f174.google.com with SMTP id w61so249378wes.5
        for <linux-wireless@vger.kernel.org>; Fri, 05 Sep 2014 05:27:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1409918136.14663.1.camel@jlt4.sipsolutions.net>
References: <1409867861-3911-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1409916684.1940.8.camel@jlt4.sipsolutions.net>
	<1409918136.14663.1.camel@jlt4.sipsolutions.net>
Date: Fri, 5 Sep 2014 14:27:14 +0200
Message-ID: <CAA2SeN+E9NfRmc8uFSL5NkJf3C6N=axh=rtNT2=h3k0KPs6aKQ@mail.gmail.com> (sfid-20140905_142720_128171_95D2A534)
Subject: Re: [PATCHv5 0/2] configure dynack through mac80211/cfg80211 stack
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It sounds good. I will apply iw patchset on top of it.

Regards,
Lorenzo

2014-09-05 13:55 GMT+02:00 Johannes Berg <johannes@sipsolutions.net>:
> On Fri, 2014-09-05 at 13:31 +0200, Johannes Berg wrote:
>> On Thu, 2014-09-04 at 23:57 +0200, Lorenzo Bianconi wrote:
>> > Enable ACK timeout estimation algorithm (dynack) using mac80211
>> > set_coverage_class API. Dynack is activated passing -1 as coverage class
>> > to lower drivers and it is automatically disabled setting valid value for
>> > coverage class. Currently dynack is supported just by ath9k.
>> > Fix set_coverage_class signature for p54, ath9k, ath9k_htc and ath5k drivers.
>>
>> Applied.
>
> Forgot to say - I renumbered the nl80211 feature bit and attribute as it
> was conflicting with Emmanuel's patches (and it was easier to resolve
> this way around)
>
> johannes
>



-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
