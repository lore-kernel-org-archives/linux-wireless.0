Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:40480 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab0AFPHI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 10:07:08 -0500
Received: by ewy19 with SMTP id 19so9690170ewy.21
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2010 07:07:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <op.u5w2vyof9lhzdc@linux-g0th.site>
References: <op.u5w2vyof9lhzdc@linux-g0th.site>
Date: Wed, 6 Jan 2010 16:07:05 +0100
Message-ID: <b170af451001060707j3db4d8b6tec92f9c737ba40df@mail.gmail.com>
Subject: Re: [PATCH] b43: N-PHY: clean table init, check PHY rev (V3)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>,
	Michael Buesch <mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 2 stycznia 2010 18:58 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
> Hopefully with Michaels's mysterious suggestion applied :)
>
> From 3d54059593785a820789c5af99ca1373eaf6b2c7 Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
> Date: Sat, 2 Jan 2010 18:50:25 +0100
> Subject: [PATCH] b43: N-PHY: clean table init, check PHY rev (V3)
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
>
> Move table init to tables_nphy.c, detect newer PHY which use different init.
> We don't init newer PHYs yet but this at least shows what more is needed.
>
> V2: Make some functions and tables static
> V3: Just drop static table declarations from header

John, I've sent some N-PHY patches which were *not* generated on top
of this one. So all of them have lines offset issue when applying on
top of this.

Please ignore this patch, apply all the rest of my N-PHY patches. I'll
resend this one in some patchset later (with corrected line offset
hunk).

-- 
Rafał
