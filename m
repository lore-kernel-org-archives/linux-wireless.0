Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41862 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751272AbdBOI7A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 03:59:00 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v6 1/3] cfg80211: Accept multiple RSSI thresholds for CQM
References: <20170210090231.14696-1-andrew.zaborowski@intel.com>
        <1487147264.4026.13.camel@sipsolutions.net>
Date: Wed, 15 Feb 2017 10:58:54 +0200
In-Reply-To: <1487147264.4026.13.camel@sipsolutions.net> (Johannes Berg's
        message of "Wed, 15 Feb 2017 09:27:44 +0100")
Message-ID: <87vasb96ep.fsf@purkki.adurom.net> (sfid-20170215_100207_799325_619454F4)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2017-02-10 at 10:02 +0100, Andrew Zaborowski wrote:
>> Change the SET CQM command's RSSI threshold attribute to accept any
>> number of thresholds as a sorted array.=C2=A0=C2=A0The API should be bac=
kwards
>> compatible so that if one s32 threshold value is passed, the old
>> mechanism is enabled.=C2=A0=C2=A0The netlink event generated is the same=
 in
>> both cases.
>
> I've applied this now, thanks for your patience :)
>
> I got a bit confused - and then fixed it up - patchwork has giving your
> name as "Andrzej Zaborowski" which apparently you didn't really want
> (any more). I've fixed it for these patches to be as the patches you
> sent, but no guarantees I've done this before or will remember to do
> that in the future - if you can somehow change your name in patchwork
> (patchwork.kernel.org) that would be good.

IIRC if you haven't registered to patchwork.kernel.org it's possible to
change the name easily. But after registration the user needs to contact
helpdesk to change the name.

Please let me know if there's an easier way to change the name. This is
not the first time this comes up.

--=20
Kalle Valo
