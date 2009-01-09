Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:33309 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbZAILL4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 06:11:56 -0500
Received: by bwz14 with SMTP id 14so28747961bwz.13
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 03:11:55 -0800 (PST)
Message-ID: <41960ccf0901090311k6165bd36rf2b70b443a0058f7@mail.gmail.com> (sfid-20090109_121159_433878_6529D24D)
Date: Fri, 9 Jan 2009 12:11:55 +0100
From: "Lorenzo Nava" <navalorenx@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [b43] opensource firmware
Cc: "Francesco Gringoli" <francesco.gringoli@ing.unibs.it>,
	linux-wireless@vger.kernel.org,
	"David Woodhouse" <dwmw2@infradead.org>
In-Reply-To: <200901091206.09736.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200901091129.22708.mb@bu3sch.de> <200901091149.28683.mb@bu3sch.de>
	 <9F70A0D3-6334-45FB-9DAF-263FE89C847E@ing.unibs.it>
	 <200901091206.09736.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

the only advice that I can give you is to pay attention to have the
correct initvals: firmware need v480 firmware initvals.

regards

Lorenzo.

2009/1/9 Michael Buesch <mb@bu3sch.de>:
> On Friday 09 January 2009 12:00:41 Francesco Gringoli wrote:
>> I think someone else other than us two (me and Lorenzo, here) should
>> test the firmware. Have you tested it on your boards?
>
> Yep, it doesn't work.
> So I'll first try to (partially) merge it into my git repository and give it an extra review.
>
> --
> Greetings, Michael.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
