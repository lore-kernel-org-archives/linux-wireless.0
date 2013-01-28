Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:61360 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab3A1PKn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 10:10:43 -0500
Received: by mail-qa0-f42.google.com with SMTP id cr7so569563qab.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2013 07:10:42 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <87pq0pcrpy.fsf@purkki.adurom.net>
References: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
	<1359377405.8120.16.camel@jlt4.sipsolutions.net>
	<87pq0pcrpy.fsf@purkki.adurom.net>
Date: Mon, 28 Jan 2013 16:10:42 +0100
Message-ID: <CA+icZUUhDgyez9vwrMLiLP1CERq12rYpbPpyB--9ECZ0dbuvwg@mail.gmail.com> (sfid-20130128_161049_382879_8AC255D7)
Subject: Re: [PATCH 0/37] iwlwifi: add the MVM driver
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 28, 2013 at 3:22 PM, Kalle Valo <kvalo@adurom.com> wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>
>> Question for the list ...
>>
>> Internally, we've identified patches to this new driver as
>>
>> "iwlwifi (MVM):"
>>
>> rather than just "iwlwifi:"
>>
>> We can continue doing so (and would probably also tag patches with
>> "iwlwifi" for core and "iwlwifi (DVM)" for the DVM part.
>>
>> Would "iwlmvm"/"iwldvm"/"iwlwifi" make more sense as that's the module
>> names? It's harder to filter though, I guess.
>
> I would use this:
>
> "iwlwifi: mvm: fix foo"
>

If two-items notation then "item1: item2: Subject" is better than the
commata notation "iwlwifi, mwm: Fix foo" should simply die...

More Like-it (mostly seen in media):

[subtree|driver-family|etc.] special-driver|script|etc: Subject

For example:

"[kbuild] deb-pkg: Bump year in copyright

(kbuild subtree and debbuild script (aka make deb-pkg).

And yes, I like capital letter in the first word of subject (after ":").

Two items is OK.
But more items seen for rtlwifi sth. like "rtlwifi: rtlX: rtlY: rtlZ:
Here now what I wanted to fix" is IMHO bad for extracting patches with
git.

BTW, why do you need two items?
Is there somewhere a mvm driver in another subtree?
Or new buzz-word: What about "iwlmvm"?
iwlegacy - iwlwifi - iwlmvm...

- Sedat -

> I don't remember where I saw that style first but I liked it.
>
> --
> Kalle Valo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
