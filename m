Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:62315 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbaDIHHL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 03:07:11 -0400
Received: by mail-wi0-f169.google.com with SMTP id hm4so9037701wib.2
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 00:07:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1396965618.4418.17.camel@dubbel>
References: <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
	<1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
	<1396963807.11971.2.camel@jlt4.sipsolutions.net>
	<1396965618.4418.17.camel@dubbel>
Date: Wed, 9 Apr 2014 09:07:09 +0200
Message-ID: <CA+BoTQmYDRKdTForQXgFwY_g_8HnJqKh3=hBj430QUTQKo6mZQ@mail.gmail.com> (sfid-20140409_090715_587149_3F862F41)
Subject: Re: [PATCH v3 00/13] cfg80211/mac80211: implement multi-vif chanctx reservations
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 April 2014 16:00, Luca Coelho <luca@coelho.fi> wrote:
> On Tue, 2014-04-08 at 15:30 +0200, Johannes Berg wrote:
>> On Mon, 2014-03-31 at 12:39 +0200, Michal Kazior wrote:
>> > Hi,
>> >
>> > This is part of my multi-vif csa work. These
>> > patches have been included in my recent big RFC.
>> > I'm trying to split it up a bit.
>> >
>> > The patchset incrementally improves chanctx
>> > reservations in order to support multi-vif
>> > reservations and in-place multi-vif reservations
>> > (typically for single-channel hardware, but
>> > multi-channel benefits from this too).
>> >
>> > Some of the patches (the refcounting) were also
>> > posted a while ago as a separate small RFC.
>> >
>> > This is rebased on mac80211-next/master and my
>> > CSA fixes/cleanups now.
>>
>> I guess this looks fine ... Is Luca planning to pick it up first?
>
> I can do that, whichever you prefer.
>
> But Michal is going to resend with some comments by Eliad addressed,
> right?

Yes. I'm planning to re-spin today.


Michał
