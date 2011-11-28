Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56841 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab1K1QCD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 11:02:03 -0500
Received: by eaak14 with SMTP id k14so1940124eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 08:02:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACna6ryNkHeVXWXxFfod1-KQs8HQVv7wF-xpY5MA-Qs6fCypCg@mail.gmail.com>
References: <4ED3A6E8.4050000@aol.com>
	<CACna6ryNkHeVXWXxFfod1-KQs8HQVv7wF-xpY5MA-Qs6fCypCg@mail.gmail.com>
Date: Mon, 28 Nov 2011 17:02:02 +0100
Message-ID: <CACna6rzRJgfddE4jPivxBJCCZEyKSHsdRX7cE15rRxk2nhiRkA@mail.gmail.com> (sfid-20111128_170208_008373_B5FCEE5C)
Subject: Re: Trouble with Macbook Pro 8,2 (broadcom 4331) and latest b43
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: AndrewL733 <AndrewL733@aol.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 28 listopada 2011 16:59 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
> I can give you some hints:
> 1) find -name "b43.ko" /lib/modules

I meant
find /lib/modules -name "b43.ko"

Anyway, the problem lies in compat-wireless installation. I don't
understand the following part:
make[1]: *** [_emodinst_post] Error 1
 make[1]: Leaving directory `/usr/src/devel/3.1.2-1.1-desktop'
 make: *** [install-modules] Error 2
(don't know where it comes from)

-- 
Rafał
