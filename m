Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:36371 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab0ANXNS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 18:13:18 -0500
Received: by ewy1 with SMTP id 1so106001ewy.28
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 15:13:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e891001141508ndec9aeak46412482b2486054@mail.gmail.com>
References: <op.u6jn12l09lhzdc@linux-g0th.site>
	 <43e72e891001141508ndec9aeak46412482b2486054@mail.gmail.com>
Date: Fri, 15 Jan 2010 00:13:15 +0100
Message-ID: <b170af451001141513p6452cf52q6d97477a38e83f34@mail.gmail.com>
Subject: Re: [PATCH 3/6] b43: N-PHY: add update TX cal ladder
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 15 stycznia 2010 00:08 użytkownik Luis R. Rodriguez
<mcgrof@gmail.com> napisał:
> It'd be nice if your patches had a good description of what this is, I
> see most of these patches are one-liners with no description at all.

That's right, because I just implement function by function using
specs. I guess that's how implementing driver from RE specs look like.

Maybe I could use descriptions instead of function names so we would get
calculate TX IQ LO
instead of
b43_nphy_cal_tx_iq_lo
but not sure if that makes much more sense.

Do you have some better suggestion? I'm open for comments, changes :)

-- 
Rafał
