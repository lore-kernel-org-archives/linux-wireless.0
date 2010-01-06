Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:46435 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276Ab0AFT3i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 14:29:38 -0500
Received: by ewy19 with SMTP id 19so9965974ewy.21
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2010 11:29:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201001061922.58203.mb@bu3sch.de>
References: <op.u54a59c89lhzdc@linux-g0th.site>
	 <43e72e891001060926s320bf403ya2edf2601ced5125@mail.gmail.com>
	 <b170af451001061018x6ff2404ajbdbb3cb96ceaf7f2@mail.gmail.com>
	 <201001061922.58203.mb@bu3sch.de>
Date: Wed, 6 Jan 2010 20:29:36 +0100
Message-ID: <b170af451001061129n59357edehc1f2328fb10846f6@mail.gmail.com>
Subject: Re: [PATCH 2/5] b43: N-PHY: b43_nphy_get_tx_gains
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 6 stycznia 2010 19:22 użytkownik Michael Buesch <mb@bu3sch.de> napisał:
> On Wednesday 06 January 2010 19:18:39 Rafał Miłecki wrote:
>> > Dude what is up with this e-mail data on your patches in the commit log?
>>
>> That is way of encoding non-ASCII chars in mail header. You can find
>> info about this in RFC. That is "=?UTF-8?B?" prefix and base 64
>> encoded text.
>>
>> That was generated with git (git format-patch -5) and it understood by
>> git (git am ...).
>
> Well, however, there is no reason to include this in the mail body (and thus
> the GIT commit message).
> As you said, these are mail _headers_.
> Additionally, attaching the patch as mail attachment is _not_ required. We just
> put the patch into the body.

OK, will try to follow that. I checked few patches submitted by other
ppl so probably get the correct way this time.


> You may read Documentation/SubmittingPatches and format your future
> patches according to that.

Well, that's really poor joke :| Manually creating .orig files, using
"diff -up" and so dropping local commits "strategy"...? Er, I don't
think I'll use this one.

-- 
Rafał
