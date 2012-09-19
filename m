Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:36291 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab2ISUKb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 16:10:31 -0400
Received: by qaas11 with SMTP id s11so3774289qaa.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Sep 2012 13:10:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1348053493-22955-2-git-send-email-jarl@softace.dk>
References: <1348053493-22955-1-git-send-email-jarl@softace.dk> <1348053493-22955-2-git-send-email-jarl@softace.dk>
From: Jarl Friis <jarl@softace.dk>
Date: Wed, 19 Sep 2012 22:10:10 +0200
Message-ID: <CAOjsGA2uvCxnX1PH85w2vO894kZT+af-Tgj7bV-3kw3ScxN10g@mail.gmail.com> (sfid-20120919_221037_184694_EE20C4D4)
Subject: Re: [PATCH 2/2] Using LP firmware for taking advantage of the
 low-power capabilities.
To: Stefano Brivio <stefano.brivio@polimi.it>,
	=?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	netdev@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Jarl Friis <jarl@softace.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/9/19 Jarl Friis <jarl@softace.dk>:
> This is using the LP specific firmware to better take advantage of the
> Low-Power capabilities.

Gosh... I just realized that the code I introduced is completely
untested. My hardware does not reach these pieces of code...

Sorry...

However the code seems natural (due to the firmware file name pattern)
for a PHY-LP hardware, that is a bcm4313 chip (pciid 14e4:4315).

So if there is anybody with such hardware... you might want to try it... Sorry.

Jarl
