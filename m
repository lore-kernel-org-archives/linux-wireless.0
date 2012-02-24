Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50135 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab2BXHQk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 02:16:40 -0500
Subject: Re: [PATCH] mac80211 radiotap injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Lars Bro <larsbro@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20120221T000341-610@post.gmane.org> (sfid-20120221_001738_057595_CEF930DD)
References: <loom.20120221T000341-610@post.gmane.org>
	 (sfid-20120221_001738_057595_CEF930DD)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Feb 2012 08:16:37 +0100
Message-ID: <1330067797.3426.1.camel@jlt3.sipsolutions.net> (sfid-20120224_081642_302207_4233DED7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-02-20 at 23:17 +0000, Lars Bro wrote:

> @@ -555,6 +559,7 @@ struct ieee80211_tx_info {
>  			struct ieee80211_vif *vif;
>  			struct ieee80211_key_conf *hw_key;
>  			struct ieee80211_sta *sta;
> +			u8 tx_power;
>  		} control;

Also, have you counted the bytes here and tried to compile this on a
64-bit machine? Not going to work.

johannes

