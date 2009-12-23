Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45583 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbZLWSlA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 13:41:00 -0500
Received: by ewy19 with SMTP id 19so6631397ewy.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2009 10:40:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200912231926.17206.mb@bu3sch.de>
References: <b170af450912230401l7a27b981o42cdbc96e5a16b57@mail.gmail.com>
	 <4B325F27.4020506@lwfinger.net> <200912231926.17206.mb@bu3sch.de>
Date: Wed, 23 Dec 2009 19:40:59 +0100
Message-ID: <b170af450912231040h4b18614dw26a4f2f403e7048b@mail.gmail.com>
Subject: Re: [PATCH][resend with linux-wireless] b43: N-PHY: clean table init,
	check PHY rev
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/12/23 Michael Buesch <mb@bu3sch.de>:
> On Wednesday 23 December 2009 19:19:19 Larry Finger wrote:
>> ACK for the relocation of the tables.
>
> Well, the _tables_ aren't actually relocated with that patch. The tables
> are already in the tables_nphy.c file. You just relocate the functions that upload
> the tables.

Yeah, I believe we all meant "table init relocation" :)


> So if you want to relocate the upload-functions, the question arises whether
> the tables should be made static.

Good catch, thanks. Didn't think about that. I'll post new version.


Thank you guys for help, talk :)

-- 
Rafał
