Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f51.google.com ([209.85.210.51]:50752 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab1FSJnq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 05:43:46 -0400
Received: by pzk26 with SMTP id 26so2980505pzk.10
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jun 2011 02:43:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1308478641-6207-3-git-send-email-zajec5@gmail.com>
References: <1308478641-6207-1-git-send-email-zajec5@gmail.com>
	<1308478641-6207-3-git-send-email-zajec5@gmail.com>
Date: Sun, 19 Jun 2011 11:43:46 +0200
Message-ID: <BANLkTikBHeNqB6bvo9ziA2OVcm=Swx_tCQ@mail.gmail.com> (sfid-20110619_114349_780163_BC1743A9)
Subject: Re: [PATCH 3/3] b43: HT-PHY: switch radio to requested channel
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 19 czerwca 2011 12:17 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
>>>> Something different happening with udelay 30
>  radio_read(0x002b) -> 0x0008
> radio_write(0x002b) <- 0x0008

I meant udelay 50 ofc. The code it alright. Here goes the proof:
W 2 3855.940527 9 0xb06003da 0x0 0x0 0
W 2 3855.940578 9 0xb06003d8 0x22b 0x0 0
R 2 3855.940581 9 0xb06003da 0x8 0x0 0
W 2 3855.940583 9 0xb06003d8 0x2b 0x0 0
W 2 3855.940584 9 0xb06003da 0x8 0x0 0

940578 - 940527 = 51 us

-- 
Rafał
