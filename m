Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:36703 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753189AbXLHNZi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2007 08:25:38 -0500
Date: Sat, 8 Dec 2007 14:19:53 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/4] iwlwifi: Update to changed mac80211 rate control
 interface
Message-ID: <20071208141953.1233aa30@morte> (sfid-20071208_132542_373101_26E2398C)
In-Reply-To: <1197112911.7472.50.camel@localhost>
References: <1197112439.7472.34.camel@localhost>
	<1197112911.7472.50.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 08 Dec 2007 12:21:51 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:

> This brings iwlwifi rate control code back in sync with mac80211.
> 
> Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>

It doesn't apply:

> @@ -674,32 +657,19 @@ static struct ieee80211_rate *rs_get_rate(void *priv_rate,
>  	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);

struct ieee80211_conf *conf = &local->hw.conf;

>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;


--
Ciao
Stefano
