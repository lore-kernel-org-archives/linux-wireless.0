Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38397 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981Ab2JQMpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2012 08:45:16 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so7338393oag.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Oct 2012 05:45:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <507EA183.10409@openwrt.org>
References: <1350474643-59518-1-git-send-email-nbd@openwrt.org>
	<CAD2nsn3ceRowmsxsssXT1TQYeWDxH9dby8=mFDJvV++dESJQYA@mail.gmail.com>
	<507EA183.10409@openwrt.org>
Date: Wed, 17 Oct 2012 18:15:16 +0530
Message-ID: <CAD2nsn3fP276R-Kix5HQYF-FMNxpmNUmWo3nSO0uc7UxyFv=EA@mail.gmail.com> (sfid-20121017_144522_224635_5FED1E23)
Subject: Re: [PATCH 3.7] Revert "ath9k_hw: Updated AR9003 tx gain table for 5GHz"
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, rmanohar@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 17, 2012 at 5:46 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2012-10-17 1:59 PM, Mohammed Shafi wrote:
>> Hi Felix,
>>
>> On Wed, Oct 17, 2012 at 5:20 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>>> This reverts commit a240dc7b3c7463bd60cf0a9b2a90f52f78aae0fd.
>>>
>>> This commit is reducing tx power by at least 10 db on some devices,
>>> e.g. the Buffalo WZR-HP-G450H.
>>
>> a minor concern, seems to be a reasonable amount of changes in the initvals.
>> should be fine with the stable kernel releases, just worried about
>> merge conflicts ?
> This particular gain table hasn't changed in a while, I don't expect any
> merge conflicts.

oh, ok. thanks for the clarification.

> I've had this patch for a while, as I was waiting for a response from
> the team that made the change in the first place. I never got a proper
> response from that team, so I'm sending the revert now.
>
> - Felix



-- 
thanks,
shafi
