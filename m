Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40554 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751255AbZDPL6c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 07:58:32 -0400
Cc: nbd@openwrt.org, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com
Content-Type: text/plain; charset=iso-8859-1
Date: Thu, 16 Apr 2009 13:58:30 +0200
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <20090416003818.GF4138@makis>
Message-ID: <20090416115830.305980@gmx.net> (sfid-20090416_135836_349228_7BE2C0C5)
MIME-Version: 1.0
References: <20090416003818.GF4138@makis>
Subject: Re: [PATCH 6/7] ath5k: Implement antenna control
To: Nick Kossifidis <mick@madwifi-project.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Nick!

>  * Add code to support the various antenna scenarios supported by hw
>=20
>  * For now hardcode the default scenario (single or dual omnis with
>  tx/rx diversity working and tx antenna handled by session -hw keeps
>  track on which antenna it got ack from each ap/station and maps each
>  ap/station to one of the antennas-).

We should add or update an existing nl80211 call, to allow set the used=
 antenna (multiple antennas in Draft-N?) manually, like madwifi does. T=
his is e.g. needed for long distance links.

Regards
Alina

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger01
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
