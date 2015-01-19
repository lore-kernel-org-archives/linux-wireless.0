Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:50008 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbbASBbh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2015 20:31:37 -0500
Received: by mail-ie0-f178.google.com with SMTP id vy18so28570608iec.9
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2015 17:31:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+A7n+gzarweW+ENOfx+QmCGHy+0Vu6qzPM70cPMxe5FTMwCUw@mail.gmail.com>
References: <CA+A7n+jFWWs-U2DapExRqYgK=e2kGowPzFHJPh72DRwzBmVggg@mail.gmail.com>
	<54991B32.2010105@rempel-privat.de>
	<CA+A7n+hbr2ctPkSta9-MWT1opAT2hCB9jYHvFu7N3C_ZvxXSzw@mail.gmail.com>
	<5499A391.2060705@rempel-privat.de>
	<CA+A7n+iHKBxy3qfjzrnN7GdZhJ-WwoDdi6hjw8RSaDs8TBznvw@mail.gmail.com>
	<549E6C1A.7010805@rempel-privat.de>
	<CA+A7n+gP6h1HT5F7oDY-SDrrAAjbtTHAtY0683Fe7QdVb7byfQ@mail.gmail.com>
	<CA+A7n+jQQNWk2CqoS9QQFODRsi8k4asjWE=5_q681E6PTiQM+A@mail.gmail.com>
	<54B69807.9030906@rempel-privat.de>
	<CA+A7n+gzarweW+ENOfx+QmCGHy+0Vu6qzPM70cPMxe5FTMwCUw@mail.gmail.com>
Date: Sun, 18 Jan 2015 20:31:36 -0500
Message-ID: <CA+A7n+j4dcsRc9yb6PyWAJZD-eUu2SQsy+R_Rk0NbSmfN_RVeA@mail.gmail.com> (sfid-20150119_023143_287206_EDC23CE9)
Subject: Re: bug report for ath9k_htc driver
From: Jeremy Audet <ichimonji10@gmail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org, Adrian Chadd <adrian@freebsd.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No luck. [1] For what it's worth, the TL-WN722N's LEDs did not light
up after executing `ip link set dev $device up`, so I am pretty sure
that the `echo none > ...` command worked. I do see that version 1.4
of the firmware may be released. [2] I can build and install the
firmware and see what happens. Is that worth doing? I'm not 100% which
firmware version is provided by your repo. [3]

[1] http://www.ichimonji10.name/downloads/2015-01-18.txt
[2] https://github.com/qca/open-ath9k-htc-firmware/issues/65
[3] https://github.com/olerem/ath9k-htc-firmware-blob

—Jeremy 'Ichimonji10' Audet
