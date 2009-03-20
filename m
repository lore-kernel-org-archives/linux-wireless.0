Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39534 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751731AbZCTWtX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 18:49:23 -0400
Cc: otus-devel@lists.madwifi-project.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Fri, 20 Mar 2009 23:49:20 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <200903202312.57737.chunkeey@web.de>
Message-ID: <20090320224920.261010@gmx.net> (sfid-20090320_234926_249162_145A0742)
MIME-Version: 1.0
References: <200903170408.12626.chunkeey@web.de>
 <200903202214.51394.chunkeey@web.de> <20090320212515.GA12078@kroah.com>
 <200903202312.57737.chunkeey@web.de>
Subject: Re: [RFC][RFT][PATCH 0/5 v5] ar9170: ar9170 driver (aka mac80211's
 otus)
To: Christian Lamparter <chunkeey@web.de>, greg@kroah.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

> Well, a few features that the vendors uses to encourage potential buy=
ers:
> - HT ( 802.11n - aka 300mbps )

Hopefully someone can implement it.

> - AP/AD-Hoc=20

Ad-Hoc mode with fixed BSSIDs works absolutely fine with this driver. I=
 only didn't find a way to reset the TSF, so that IBSS merges works sta=
ndard compliant.

In the praxis all mesh networks uses fixed BSSIDs.

Regards
Alina

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
