Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42833 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab3A1PiG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 10:38:06 -0500
Message-ID: <1359387506.8120.20.camel@jlt4.sipsolutions.net> (sfid-20130128_163810_620132_ACEEBCFB)
Subject: Re: [PATCH 0/37] iwlwifi: add the MVM driver
From: Johannes Berg <johannes@sipsolutions.net>
To: sedat.dilek@gmail.com
Cc: Kalle Valo <kvalo@adurom.com>, linux-wireless@vger.kernel.org
Date: Mon, 28 Jan 2013 16:38:26 +0100
In-Reply-To: <CA+icZUXx+Pt2vwMgvOCGdT5GiwASQ_mMfLBt_vxUJCPu4aXe9w@mail.gmail.com> (sfid-20130128_161735_716380_35D1A2D2)
References: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
	 <1359377405.8120.16.camel@jlt4.sipsolutions.net>
	 <87pq0pcrpy.fsf@purkki.adurom.net>
	 <CA+icZUUhDgyez9vwrMLiLP1CERq12rYpbPpyB--9ECZ0dbuvwg@mail.gmail.com>
	 <CA+icZUXx+Pt2vwMgvOCGdT5GiwASQ_mMfLBt_vxUJCPu4aXe9w@mail.gmail.com>
	 (sfid-20130128_161735_716380_35D1A2D2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-01-28 at 16:17 +0100, Sedat Dilek wrote:
> On Mon, Jan 28, 2013 at 4:10 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> > On Mon, Jan 28, 2013 at 3:22 PM, Kalle Valo <kvalo@adurom.com> wrote:
> >> Johannes Berg <johannes@sipsolutions.net> writes:
> >>
> >>> Question for the list ...
> >>>
> >>> Internally, we've identified patches to this new driver as
> >>>
> >>> "iwlwifi (MVM):"
> >>>
> >>> rather than just "iwlwifi:"
> >>>
> >>> We can continue doing so (and would probably also tag patches with
> >>> "iwlwifi" for core and "iwlwifi (DVM)" for the DVM part.
> >>>
> >>> Would "iwlmvm"/"iwldvm"/"iwlwifi" make more sense as that's the module
> >>> names? It's harder to filter though, I guess.
> >>
> >> I would use this:
> >>
> >> "iwlwifi: mvm: fix foo"
> >>
> >
> > If two-items notation then "item1: item2: Subject" is better than the
> > commata notation "iwlwifi, mwm: Fix foo" should simply die...
> >
> > More Like-it (mostly seen in media):
> >
> > [subtree|driver-family|etc.] special-driver|script|etc: Subject
> >
> > For example:
> >
> > "[kbuild] deb-pkg: Bump year in copyright
> >
> > (kbuild subtree and debbuild script (aka make deb-pkg).
> >
> > And yes, I like capital letter in the first word of subject (after ":").
> >
> > Two items is OK.
> > But more items seen for rtlwifi sth. like "rtlwifi: rtlX: rtlY: rtlZ:
> > Here now what I wanted to fix" is IMHO bad for extracting patches with
> > git.
> >
> > BTW, why do you need two items?
> > Is there somewhere a mvm driver in another subtree?
> > Or new buzz-word: What about "iwlmvm"?
> > iwlegacy - iwlwifi - iwlmvm...
> >
> 
> Better than buzz-words and personal likes/dislikes is the quality of
> the patches, the embedded (descriptive) text in changelog and a well
> documented source-code.

I'm sorry, did you read the patches?

johannes

