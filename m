Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:42826 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930AbYIHUHu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 16:07:50 -0400
Message-ID: <48C5868B.8060103@w1.fi> (sfid-20080908_220754_668779_4FC63E7B)
Date: Mon, 08 Sep 2008 23:09:47 +0300
From: Jouni Malinen <j@w1.fi>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Tomas Winkler <tomasw@gmail.com>,
	Ron Rindjunsky <rindjon@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>, j@w1.fi
Subject: Re: HT action frame code
References: <1220883730.31304.60.camel@johannes.berg>
In-Reply-To: <1220883730.31304.60.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> When we're an AP, shouldn't we also in some way honour the block-ack
> action frames? Or will that be done in hostapd, which then sets up
> block-ack via some unspecified way?

The current design assumes that hostapd takes care of all management 
frames, so eyes, these would need to go to hostapd for processing and 
then setup back to mac80211 through some new command..

- Jouni

