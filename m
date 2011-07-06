Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53191 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab1GFOdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 10:33:22 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1QeTAH-0005yn-85
	for linux-wireless@vger.kernel.org; Wed, 06 Jul 2011 16:33:21 +0200
Subject: Re: [RFC 1/2] mac80211: allow drivers to access key sequence
 counter
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <20110706121315.215752759@sipsolutions.net> (sfid-20110706_141342_555231_9BAC1052)
References: <20110706121236.333408679@sipsolutions.net>
	 <20110706121315.215752759@sipsolutions.net>
	 (sfid-20110706_141342_555231_9BAC1052)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 16:33:21 +0200
Message-ID: <1309962801.3893.9.camel@jlt3.sipsolutions.net> (sfid-20110706_163325_538947_414DF442)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-06 at 14:12 +0200, Johannes Berg wrote:

> +/**
> + * ieee80211_get_key_rx_seq - get key RX sequence counter
> + *
> + * @keyconf: the parameter passed with the set key
> + * @tid: the TID, or -1 for the non-QoS value

This is of course wrong. The -1 should be for *management* frames. I'll
fix that for the real submission.

johannes

