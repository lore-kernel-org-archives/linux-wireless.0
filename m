Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:38758 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaLWSF7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 13:05:59 -0500
Received: by mail-ig0-f175.google.com with SMTP id h15so5838485igd.2
        for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2014 10:05:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5499A391.2060705@rempel-privat.de>
References: <CA+A7n+jFWWs-U2DapExRqYgK=e2kGowPzFHJPh72DRwzBmVggg@mail.gmail.com>
	<54991B32.2010105@rempel-privat.de>
	<CA+A7n+hbr2ctPkSta9-MWT1opAT2hCB9jYHvFu7N3C_ZvxXSzw@mail.gmail.com>
	<5499A391.2060705@rempel-privat.de>
Date: Tue, 23 Dec 2014 13:05:58 -0500
Message-ID: <CA+A7n+gcZnaVjvXb8DAsOC_RsVJ5qUzKU5bFF4YhKGZs6SaYXg@mail.gmail.com> (sfid-20141223_190603_470855_06944F5E)
Subject: Re: bug report for ath9k_htc driver
From: Jeremy Audet <ichimonji10@gmail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org, Adrian Chadd <adrian@freebsd.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I would suggest to test other cable or other usb controller.
> With other words, I have no idea about the reason for initial
> disconnection. It can be bad usb connection, noise or not enough power.

Oh lordy. I connected the TL-WN722N directly to my computer, set up a
wireless access point and have been streaming music off of it for the
past 30 minutes with no issues. It appears that the issue was the USB
cradle [1] that shipped with the TL-WN722N. Thank you very much for
your help, and I'm sorry for having raised a false alarm.

-Jeremy "Ichimonji10" Audet

[1] http://www.newegg.com/Product/Product.aspx?Item=N82E16833997218
