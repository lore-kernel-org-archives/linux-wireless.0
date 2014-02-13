Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:43511 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaBMUEZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 15:04:25 -0500
Received: by mail-ob0-f171.google.com with SMTP id wp4so12839746obc.30
        for <linux-wireless@vger.kernel.org>; Thu, 13 Feb 2014 12:04:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392311186-7805-1-git-send-email-zajec5@gmail.com>
References: <1392311186-7805-1-git-send-email-zajec5@gmail.com>
Date: Thu, 13 Feb 2014 21:04:24 +0100
Message-ID: <CACna6rwDpJ0ArTHGQfq-HNDo3ZAVU4wWuRa6_Ui+ZV+6o+K7Mw@mail.gmail.com> (sfid-20140213_210434_428108_41E9E022)
Subject: Re: [3.14 FIX][PATCH] bcma: gpio: register all 32 GPIOs
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-02-13 18:06 GMT+01:00 Rafał Miłecki <zajec5@gmail.com>:
> Broadcom boards have 32 GPIOs (not 16) and these higher ones are
> actually used on some devices (for buttons, reset of WiFi devices).

I forgot about one important thing. This patch is based on top of
changes from 3.14-rc1.

John: do you plan to pull David's net.git tree into your wireless.git?
