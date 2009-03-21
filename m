Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47478 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755268AbZCUO7g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 10:59:36 -0400
Cc: linux-wireless@vger.kernel.org,
	otus-devel@lists.madwifi-project.org, greg@kroah.com,
	linville@tuxdriver.com, johannes@sipsolutions.net,
	lrodriguez@atheros.com
Content-Type: text/plain; charset=iso-8859-1
Date: Sat, 21 Mar 2009 15:59:33 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <20090320230448.261020@gmx.net>
Message-ID: <20090321145933.102650@gmx.net> (sfid-20090321_155938_208326_FD4AD920)
MIME-Version: 1.0
References: <200903170408.12626.chunkeey@web.de>
 <200903202036.09255.chunkeey@web.de> <20090320200736.261050@gmx.net>
 <200903202159.41613.chunkeey@web.de> <20090320230448.261020@gmx.net>
Subject: Re: [RFC][RFT][PATCH 0/5 v5] ar9170: ar9170 driver (aka mac80211's
 otus)
To: "Alina Friedrichsen" <x-alina@gmx.net>, chunkeey@web.de
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Christian,

your new code is not compatible with compat-wireless. The function usb_=
poison_anchored_urbs() is missing in the 2.6.27 kernel.

Regards
Alina

--=20
Aufgepasst: Sind Ihre Daten beim Online-Banking auch optimal gesch=FCtz=
t?
Jetzt absichern: https://homebanking.gmx.net/?mc=3Dmail@footer.hb
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
