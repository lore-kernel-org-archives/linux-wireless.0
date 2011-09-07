Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42157 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab1IGMYc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 08:24:32 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1R1GW4-0000cm-6j
	for linux-wireless@vger.kernel.org; Wed, 07 Sep 2011 13:42:04 +0200
Subject: Re: [RFC 4/5] mac80211: reply only once to each PS-poll
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <20110906202725.521429120@sipsolutions.net> (sfid-20110906_222829_677927_941F230D)
References: <20110906201703.703254041@sipsolutions.net>
	 <20110906202725.521429120@sipsolutions.net>
	 (sfid-20110906_222829_677927_941F230D)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Sep 2011 13:42:04 +0200
Message-ID: <1315395724.4002.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> @@ -391,6 +396,7 @@ enum mac80211_tx_control_flags {
>  	IEEE80211_TX_CTL_TX_OFFCHAN		= BIT(25),
>  	IEEE80211_TX_INTFL_TKIP_MIC_FAILURE	= BIT(26),
>  	IEEE80211_TX_STATUS_EOSP		= BIT(27),
> +	IEEE80211_TX_STATUS_PSPOLL_RESP		= BIT(28),

Also needs to be added to temporary flags.

johannes

