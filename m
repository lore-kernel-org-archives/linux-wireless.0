Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:52582 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab1LKTvW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Dec 2011 14:51:22 -0500
From: Kalle Valo <kvalo@adurom.com>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Franky Lin <frankyl@broadcom.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 05/23] bcma: add set/mask macros for 16-bit register access
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
	<1323385619-7454-6-git-send-email-frankyl@broadcom.com>
	<CACna6rwVVEYf0F6HZoMKrJg2NT3c4SPb6OH34LsTm8NR+BtsRA@mail.gmail.com>
Date: Sun, 11 Dec 2011 21:51:19 +0200
In-Reply-To: <CACna6rwVVEYf0F6HZoMKrJg2NT3c4SPb6OH34LsTm8NR+BtsRA@mail.gmail.com>
	(=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Sat, 10 Dec 2011
 12:45:26 +0100")
Message-ID: <87mxayevk8.fsf@purkki.adurom.net> (sfid-20111211_205125_437710_C1734222)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> What is an advantage of static inline over define?

Possible to use proper compiler checks and easier to read. Better to
avoid C preprocesor until it's absolutely necessary to use it, makes it
a lot easier for everyone.

-- 
Kalle Valo
