Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:34615 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab1KWQLt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 11:11:49 -0500
Message-ID: <4ECD1B40.1050203@neratec.com> (sfid-20111123_171152_576866_36BE854D)
Date: Wed, 23 Nov 2011 17:11:44 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	shafi.wireless@gmail.com, nbd@openwrt.org
Subject: Re: [PATCH 0/2] ath9k: DFS radar detection
References: <1320770044-12271-1-git-send-email-zefir.kurtisi@neratec.com> <20111115143755.GB2483@tuxdriver.com> <CAB=NE6WLvLc2UpuQ2RYagN2OhwvEZZuYTUY+Ak+wFmBPH9EfUQ@mail.gmail.com>
In-Reply-To: <CAB=NE6WLvLc2UpuQ2RYagN2OhwvEZZuYTUY+Ak+wFmBPH9EfUQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis,

any pending concerns or feedback before I start working on v2?


Zefir

On 11/15/2011 05:46 PM, Luis R. Rodriguez wrote:
> On Tue, Nov 15, 2011 at 6:37 AM, John W. Linville
> <linville@tuxdriver.com> wrote:
>> On Tue, Nov 08, 2011 at 05:34:02PM +0100, Zefir Kurtisi wrote:
>>> This patch series proposes DFS radar pulse detection for ath9k.
>>>
>>> The first patch adds a new DFS module, the second turns those
>>> knobs to enable the HW to detect radar pulses and forward them
>>> to the new module.
>>>
>>> Here, sanity and plausibility checks that are HW dependent are
>>> performed and resulting radar events are passed to higher level
>>> generic pattern detectors for further processing (spectrum
>>> management, etc.).
>>>
>>> DFS support is limited to newer chip-sets (for now 9280 and later).
>>>
>>> So far, AP operation on DFS channels is not supported by
>>> mac80211/hostapd. Testing the proposed pulse detection is done in
>>> monitor mode.
>>>
>>> Zefir Kurtisi (2):
>>>   ath9k: add DFS radar pulse processing
>>>   ath9k: integrate initial DFS module
>>
>> Any comments from the ath9k guys on this?
> 
> Just sent my initial set of comments.
> 
>   Luis

