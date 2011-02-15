Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64796 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab1BOUvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 15:51:55 -0500
Received: by qwa26 with SMTP id 26so469091qwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 12:51:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D5AD73A.70909@gmail.com>
References: <20110215221313.498d21ed.nledovskikh@gmail.com>
	<4D5AD73A.70909@gmail.com>
Date: Tue, 15 Feb 2011 23:51:55 +0300
Message-ID: <AANLkTin468evHsriKWYSJhz_Ph5UHS7GX8vtwrPZck=-@mail.gmail.com>
Subject: Re: [PATCH] ath5k: Right channel setting for ar2317 chip
From: Nikolay Ledovskikh <nledovskikh@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	lrodriguez@atheros.com, mickflemm@gmail.com, me@bobcopeland.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes, we can reuse the code.
rf2317 handled but not fully, when I tested ahb patch on bullet2 all
seemed to work fine, but it couldn't connect another host (ibss for
example). During an analysis I observed that it's transmitting on
another channel and then I looked into madwifi code and understood
that the problem is in channel setting function.

--
Best regards, Nikolay Ledovskikh.
