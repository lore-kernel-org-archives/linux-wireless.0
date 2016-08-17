Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41444 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbcHQNJN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2016 09:09:13 -0400
Message-ID: <1471439315.5173.7.camel@sipsolutions.net> (sfid-20160817_150916_803556_96561639)
Subject: Re: [PATCH] mac80211: Move crypto IV generation to after TXQ
 dequeue.
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
	make-wifi-fast@lists.bufferbloat.net,
	linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>
Date: Wed, 17 Aug 2016 15:08:35 +0200
In-Reply-To: <20160817125800.19154-1-toke@toke.dk> (sfid-20160817_150108_704551_07DBB188)
References: <20160817125800.19154-1-toke@toke.dk>
	 (sfid-20160817_150108_704551_07DBB188)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> @@ -1573,6 +1574,7 @@ struct ieee80211_key_conf {
>  	u8 iv_len;
>  	u8 hw_key_idx;
>  	u8 flags;
> +	u8 pn_offs;
> 
This is completely wrong.

johannes
