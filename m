Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53597 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336Ab1KOQqr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 11:46:47 -0500
Received: by fagn18 with SMTP id n18so591102fag.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Nov 2011 08:46:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111115143755.GB2483@tuxdriver.com>
References: <1320770044-12271-1-git-send-email-zefir.kurtisi@neratec.com> <20111115143755.GB2483@tuxdriver.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 15 Nov 2011 08:46:25 -0800
Message-ID: <CAB=NE6WLvLc2UpuQ2RYagN2OhwvEZZuYTUY+Ak+wFmBPH9EfUQ@mail.gmail.com> (sfid-20111115_174650_958122_57C2D3EC)
Subject: Re: [PATCH 0/2] ath9k: DFS radar detection
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	shafi.wireless@gmail.com, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 15, 2011 at 6:37 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Tue, Nov 08, 2011 at 05:34:02PM +0100, Zefir Kurtisi wrote:
>> This patch series proposes DFS radar pulse detection for ath9k.
>>
>> The first patch adds a new DFS module, the second turns those
>> knobs to enable the HW to detect radar pulses and forward them
>> to the new module.
>>
>> Here, sanity and plausibility checks that are HW dependent are
>> performed and resulting radar events are passed to higher level
>> generic pattern detectors for further processing (spectrum
>> management, etc.).
>>
>> DFS support is limited to newer chip-sets (for now 9280 and later).
>>
>> So far, AP operation on DFS channels is not supported by
>> mac80211/hostapd. Testing the proposed pulse detection is done in
>> monitor mode.
>>
>> Zefir Kurtisi (2):
>>   ath9k: add DFS radar pulse processing
>>   ath9k: integrate initial DFS module
>
> Any comments from the ath9k guys on this?

Just sent my initial set of comments.

  Luis
