Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:44340 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab3LJPlJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Dec 2013 10:41:09 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pali =?utf-8?Q?Roh=C3=A1r?= <pali.rohar@gmail.com>,
	Luciano Coelho <luca@coelho.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, freemangordon@abv.bg,
	aaro.koskinen@iki.fi, sre@ring0.de, joni.lapilainen@gmail.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Felipe Contreras <felipe.contreras@gmail.com>,
	David Gnedt <david.gnedt@davizone.at>
Subject: Re: [PATCH v2 01/16] wl1251: fix scan behaviour while not associated
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
	<1386494714-21070-1-git-send-email-pali.rohar@gmail.com>
	<1386494714-21070-2-git-send-email-pali.rohar@gmail.com>
	<20131210092114.GB22756@amd.pavel.ucw.cz>
Date: Tue, 10 Dec 2013 17:41:04 +0200
In-Reply-To: <20131210092114.GB22756@amd.pavel.ucw.cz> (Pavel Machek's message
	of "Tue, 10 Dec 2013 10:21:14 +0100")
Message-ID: <8738m0r9wv.fsf@purkki.adurom.net> (sfid-20131210_164115_527420_752AC32C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Machek <pavel@ucw.cz> writes:

> ssids can have \0s in them... and what is worse, they may not be 0
> terminated AFAICT.
>
> Potential solution is at
> http://www.spinics.net/lists/linux-wireless/msg98640.html . 

I just use print_hex_dump_bytes() to print SSIDs.

-- 
Kalle Valo
