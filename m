Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36833 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab0L1JMi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 04:12:38 -0500
Received: by gyb11 with SMTP id 11so3712067gyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 01:12:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293526293.3526.1.camel@jlt3.sipsolutions.net>
References: <AANLkTi=MhYzv54WvEwYGh15KC4LHyM=EVd-s+1BG8pBT@mail.gmail.com>
	<1293526293.3526.1.camel@jlt3.sipsolutions.net>
Date: Tue, 28 Dec 2010 03:12:35 -0600
Message-ID: <AANLkTik9=r8tCouEg0joexH0_S9+WPfyDGDzq5fbMKOe@mail.gmail.com>
Subject: Re: Patches submitted should apply to which git repository?
From: Naveenan <initramd@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Thanks for your email.

>> I went through:
>> http://wireless.kernel.org/en/developers/Documentation/SubmittingPatches
>> but couldn't find this information there so was hoping someone could
>> point the exact git repository. My current patch applies to
>> wireless-testing but doesn't apply to wireless-2.6 (due to a trivial
>> merge conflict) . The changes I'm making are to mac80211.
>
> If they're fixes and required in wireless-2.6, then you should make them
> apply there, but ask yourself if they really need to be there. If not,
> you can typically just submit them on top of wireless-testing, although
> they will have to be applied to wireless-next-2.6.

Would it be ok if I can send 2 different patches for both these 2 versions?

Unfortunately someone changed a line of code (that is a few lines
before my patch
but not related to it) in a recent commit to wireless-testing and this
makes the patch
not apply-able to both wireless-2.6 and wireless-next.

I would say that the fix is not a critical one would would be useful
if applied to
wireless-2.6 too.

Thanks
