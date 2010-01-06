Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44926 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab0AFTlx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 14:41:53 -0500
Received: by ewy19 with SMTP id 19so9978589ewy.21
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2010 11:41:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201001062036.55758.mb@bu3sch.de>
References: <op.u54a59c89lhzdc@linux-g0th.site>
	 <201001061922.58203.mb@bu3sch.de>
	 <b170af451001061129n59357edehc1f2328fb10846f6@mail.gmail.com>
	 <201001062036.55758.mb@bu3sch.de>
Date: Wed, 6 Jan 2010 20:41:52 +0100
Message-ID: <b170af451001061141l171682aft1130489bd8b7edf5@mail.gmail.com>
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

W dniu 6 stycznia 2010 20:36 użytkownik Michael Buesch <mb@bu3sch.de> napisał:
> On Wednesday 06 January 2010 20:29:36 Rafał Miłecki wrote:
>> > You may read Documentation/SubmittingPatches and format your future
>> > patches according to that.
>>
>> Well, that's really poor joke :| Manually creating .orig files, using
>> "diff -up" and so dropping local commits "strategy"...? Er, I don't
>> think I'll use this one.
>
> Nobody said you need to fix your internal workflow. Why would anybody care
> _how_ you generate your patches?
> You could manually type them into your cellphone with T9. If that it results
> in a properly formated patch in the end, nobody would complain.

Good one! ;)


> So yes, reading other people's patches probably is a good idea to start with.
>
> In general only put stuff into the mail that you want to show up in the commit
> message. (If you want to have additional stuff that doesn't show up in the commit
> message, you can use the "---" delimiter. But that's documented elsewhere so
> I don't have to explain that here...)

I started composing that mail before got real idea of patches. I was
still thinking I need some magic headers "diff" tool generates. Hope I
totally understand this now and won't cause more problems to you guys
:)

-- 
Rafał
