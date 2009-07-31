Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:64698 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZGaTCQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 15:02:16 -0400
Received: by yxe5 with SMTP id 5so305375yxe.33
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 12:02:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <40f31dec0907311139le0f279bl54bc897d1c716582@mail.gmail.com>
References: <20090731180805.GD7963@makis> <43e72e890907311114k5a049c08jfa40a3ed45e9afed@mail.gmail.com>
	<40f31dec0907311139le0f279bl54bc897d1c716582@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 31 Jul 2009 12:01:55 -0700
Message-ID: <43e72e890907311201k79c3d27dmd2eecbb1714bbe7c@mail.gmail.com>
Subject: Re: [PATCH 3/4] ath5k: Wakeup fixes
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2009 at 11:39 AM, Nick Kossifidis<mickflemm@gmail.com> wrote:
> 2009/7/31 Luis R. Rodriguez <mcgrof@gmail.com>:
>> On Fri, Jul 31, 2009 at 11:08 AM, Nick
>> Kossifidis<mick@madwifi-project.org> wrote:
>>>  * Don't put chip to full sleep because there are problems during
>>>   wakeup. Instead hold MAC/Baseband on warm reset state via a new
>>>   function ath5k_hw_on_hold.
>>>
>>>  * Durring attach preserve pcicfg bits when enabling pci core
>>>   sw retry fix.
>>>
>>>  * Minor cleanups
>>
>> Can you address these changes separately? I see you tend to itemize
>> the things you change, even when you just make one change. Please
>> consider addressing one change per commit and just ensure the why is
>> crystal clear.
>>
>>  Luis
>>
>
> Cleanup doesn't count as a change, the only real change is the first one.
> I 'm trying not to pollute the logs.

The purpose of the patch review cycle is to make it very easy to
review code changes, the more you split your work the easier it is to
review, that is not polluting the logs in any way.

> This patch fixes an issue reported when
> card doesn't wake up.

This is not mentioned in the commit log, please add that to the commit
log and refer to a URL if possible.

  Luis
