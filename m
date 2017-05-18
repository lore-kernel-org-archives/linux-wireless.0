Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45370 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751221AbdERGlB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 02:41:01 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: nl80211 vendor commands on upstream drivers
References: <87wp9mp4hz.fsf@kamboji.qca.qualcomm.com>
        <1495028069.2442.17.camel@sipsolutions.net>
Date: Thu, 18 May 2017 09:40:55 +0300
In-Reply-To: <1495028069.2442.17.camel@sipsolutions.net> (Johannes Berg's
        message of "Wed, 17 May 2017 15:34:29 +0200")
Message-ID: <87h90i651k.fsf@kamboji.qca.qualcomm.com> (sfid-20170518_084104_853966_0E704B50)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2017-05-12 at 16:51 +0300, Kalle Valo wrote:
>> 
>> But this does not mean that the gates are open for all possible hacks
>> via vendor commands, we still want to have generic nl80211 interface
>> for all normal functionality. Just to give some examples of something
>> which is NOT acceptable:
>
> [snip scanning]
>
>> * power save settings
>> * btcoex settings
>
> I'm starting to think that these might really be a vendor API for
> anything but the most basic features - there's so much variation here
> now.
>
> OTOH, much of these shouldn't really be something the user needs to
> twiddle with anyway.

Yeah, for example power save is something which should just work. But
btcoex settings so seem to be quite hairy sometimes, so maybe a vendor
interface is justifiable. Dunno.

-- 
Kalle Valo
