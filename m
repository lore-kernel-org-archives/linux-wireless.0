Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36052 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140AbcESNzf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2016 09:55:35 -0400
Received: by mail-wm0-f65.google.com with SMTP id w143so21174367wmw.3
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2016 06:55:34 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lauri Kasanen <cand@gmx.com>, linux-wireless@vger.kernel.org
Subject: Re: [RESEND] Re: updating carl9170-1.fw in linux-firmware.git
Date: Thu, 19 May 2016 15:55:30 +0200
Message-ID: <5231682.U0x3GAUzZo@debian64> (sfid-20160519_155538_607614_CFF01F26)
In-Reply-To: <87wpmqdwlh.fsf@kamboji.qca.qualcomm.com>
References: <20160416113312.8de2266358165182bb4b4a15@gmx.com> <20160518114828.bfaef9e4fbe9e039687eab38@gmx.com> <87wpmqdwlh.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, May 19, 2016 04:08:10 PM Kalle Valo wrote:
> Lauri Kasanen <cand@gmx.com> writes:
> 
> > On Tue, 03 May 2016 15:09:39 +0200
> > Christian Lamparter <chunkeey@googlemail.com> wrote:
> >
> >> On Thursday, April 21, 2016 03:22:15 PM Kalle Valo wrote:
> >> > Christian Lamparter <chunkeey@googlemail.com> writes:
> >> > 
> >> > > Maintainers. So for those people reading the fw list:
> >> > >
> >> > > What would it take to update the carl9170-1.fw firmware file in your
> >> > > repository to the latest version?
> >> > 
> >> > Thanks for following up on this. It would be good to solve this finally.
> >> Well, this was almost two weeks and no update yet.
> >> Kalle, can you please apply the "[PATCH v2] carl9170: Clarify kconfig text"
> >> patch from "Lauri Kasanen <cand@gmx.com>" [0].
> >> 
> >> [0] <https://marc.info/?l=linux-wireless&m=146081633405880>
> >
> > Seems we missed 4.7?
> 
> Yeah, I didn't consider this important enough and delayed it due to lack
> of time. I now put the patch back to my queue for 4.8, but please check
> that it's the correct version:
> 
> https://patchwork.kernel.org/patch/8861621/
Yes, this links to v2, which is the correct version.
 
> But we really should figure out how to get the latest version to
> linux-firmware, this is not good in the long run.
Well, none of my firmware patches were added/accepted and nobody
responded on how to add it to linux-firmware. I'm open for ideas.

Regards,
Christan
