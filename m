Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:64651 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757515Ab0ANXoo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 18:44:44 -0500
Received: by pwj9 with SMTP id 9so453109pwj.21
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 15:44:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b170af451001141513p6452cf52q6d97477a38e83f34@mail.gmail.com>
References: <op.u6jn12l09lhzdc@linux-g0th.site> <43e72e891001141508ndec9aeak46412482b2486054@mail.gmail.com>
	<b170af451001141513p6452cf52q6d97477a38e83f34@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 14 Jan 2010 15:44:23 -0800
Message-ID: <43e72e891001141544n75de8362ke1756882ed1c2391@mail.gmail.com>
Subject: Re: [PATCH 3/6] b43: N-PHY: add update TX cal ladder
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/14 Rafał Miłecki <zajec5@gmail.com>:
> W dniu 15 stycznia 2010 00:08 użytkownik Luis R. Rodriguez
> <mcgrof@gmail.com> napisał:
>> It'd be nice if your patches had a good description of what this is, I
>> see most of these patches are one-liners with no description at all.
>
> That's right, because I just implement function by function using
> specs. I guess that's how implementing driver from RE specs look like.
>
> Maybe I could use descriptions instead of function names so we would get
> calculate TX IQ LO
> instead of
> b43_nphy_cal_tx_iq_lo
> but not sure if that makes much more sense.
>
> Do you have some better suggestion? I'm open for comments, changes :)

I'm talking about the text on the commit log after the "Subject", the
subject in this case being:

"b43: N-PHY: add update TX cal ladder"

Doesn't the spec talk or even speculate to some degree what this thing is?

  Luis
