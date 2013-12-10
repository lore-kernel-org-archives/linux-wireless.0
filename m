Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:50365 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab3LJPg6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Dec 2013 10:36:58 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Luciano Coelho <luca@coelho.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, freemangordon@abv.bg,
	aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
	joni.lapilainen@gmail.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: [PATCH v2 14/16] wl1251: Add sysfs file tx_mgmt_frm_rate for setting rate
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
	<1386494714-21070-1-git-send-email-pali.rohar@gmail.com>
	<1386494714-21070-15-git-send-email-pali.rohar@gmail.com>
Date: Tue, 10 Dec 2013 17:36:52 +0200
In-Reply-To: <1386494714-21070-15-git-send-email-pali.rohar@gmail.com>
 ("Pali
	=?utf-8?Q?Roh=C3=A1r=22's?= message of "Sun, 8 Dec 2013 10:25:12 +0100")
Message-ID: <877gbcra3v.fsf@purkki.adurom.net> (sfid-20131210_163701_966789_251314E5)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pali Rohár <pali.rohar@gmail.com> writes:

> This patch adds support for configuring reg domains.
> Patch was extracted from Maemo 2.6.28 kernel.
>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

[...]

> +	/* FIXME: what's the maximum length of buf? page size?*/
> +	len = 500;

Based on the comment here I'm guessing that I wrote this horrible hack :)

I can't recall anymore why it was needed, maybe something for BT coex?
But this code should never go upstream.

-- 
Kalle Valo
