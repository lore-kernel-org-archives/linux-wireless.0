Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47788 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbYJ2J0J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 05:26:09 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 02:26:09 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18696.11155.901222.622630@gargle.gargle.HOWL> (sfid-20081029_102615_048193_2E55653F)
Date: Wed, 29 Oct 2008 14:53:31 +0530
To: Tomas Winkler <tomasw@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 04/16] ath9k: Remove SM Power Save as it is not
 supported now
In-Reply-To: <1ba2fa240810290214r57f097fcsed092776af077c7f@mail.gmail.com>
References: <18695.59972.967807.657751@gargle.gargle.HOWL>
	<1ba2fa240810290214r57f097fcsed092776af077c7f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler wrote:
> Is not supported by HW or by mac80211? It's not clear from the commit message?
> Since I'm still trying to push this into mac80211 it was just delayed
> by other tasks
> Tomas
> 

That was just legacy code maintaining a STA's PS state within the driver,
which logically should be in the stack, so it has been removed.

Sujith
