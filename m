Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52924 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbbCMO1J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 10:27:09 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Chen Gang <xili_gchen_5257@hotmail.com>,
	Jim Davis <jim.epost@gmail.com>
Subject: Re: [PATCH 1/3] bcma: move PCI IRQ control function to host specific code
References: <1425576312-2779-1-git-send-email-zajec5@gmail.com>
Date: Fri, 13 Mar 2015 16:27:03 +0200
In-Reply-To: <1425576312-2779-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Thu, 5 Mar 2015
 18:25:10 +0100")
Message-ID: <87oanxq8g8.fsf@kamboji.qca.qualcomm.com> (sfid-20150313_152714_538584_094448AC)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> This function isn't really related to any bus core. It touches PCI
> device config registers only, so move it to the (PCI) host file.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, all three patches manually applied to wireless-drivers-next.

-- 
Kalle Valo
