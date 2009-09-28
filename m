Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:37839 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbZI1HnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 03:43:04 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: ath5k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] Fw: Cannot register at bugzilla (bugreport added) [ ath5k bugreport ]
Date: Mon, 28 Sep 2009 09:42:55 +0200
Cc: Florian Mickler <florian@mickler.org>,
	"Hans-J. Ullrich" <hans.ullrich@loop.de>,
	Jiri Slaby <jirislaby@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>, netdev@vger.kernel.org
References: <20090925191524.7b2b228c@schatten>
In-Reply-To: <20090925191524.7b2b228c@schatten>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909280942.55317.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> There are already other reports of this problem in discussion 
forums.
> It seems, the old madwifi-driver works better with dhcp - so 
people say.

I cannot second that. For me, ath5k works perfectly with DHCP,
with WEXT ("iwconfig") and NL80211 ("iw") and with
wpa_supplicant.

DHCP was NEVER an issue.

-- 
http://www.holgerschurig.de
