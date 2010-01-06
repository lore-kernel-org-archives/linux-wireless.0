Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43663 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458Ab0AFSSl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 13:18:41 -0500
Received: by ewy19 with SMTP id 19so9891975ewy.21
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2010 10:18:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e891001060926s320bf403ya2edf2601ced5125@mail.gmail.com>
References: <op.u54a59c89lhzdc@linux-g0th.site>
	 <43e72e891001060926s320bf403ya2edf2601ced5125@mail.gmail.com>
Date: Wed, 6 Jan 2010 19:18:39 +0100
Message-ID: <b170af451001061018x6ff2404ajbdbb3cb96ceaf7f2@mail.gmail.com>
Subject: Re: [PATCH 2/5] b43: N-PHY: b43_nphy_get_tx_gains
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 6 stycznia 2010 18:26 użytkownik Luis R. Rodriguez
<mcgrof@gmail.com> napisał:
> 2010/1/6 Rafał Miłecki <zajec5@gmail.com>:
>> b43: N-PHY: b43_nphy_get_tx_gains
>>
>>
>> From 5c96b3de80f7d044c42808e8123ae3f50916d6fc Mon Sep 17 00:00:00 2001
>> From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
>> Date: Wed, 6 Jan 2010 15:25:14 +0100
>> Subject: [PATCH 2/5] b43: N-PHY: b43_nphy_get_tx_gains
>> MIME-Version: 1.0
>> Content-Type: text/plain; charset=UTF-8
>> Content-Transfer-Encoding: 8bit
>
> Dude what is up with this e-mail data on your patches in the commit log?

That is way of encoding non-ASCII chars in mail header. You can find
info about this in RFC. That is "=?UTF-8?B?" prefix and base 64
encoded text.

That was generated with git (git format-patch -5) and it understood by
git (git am ...).

-- 
Rafał
