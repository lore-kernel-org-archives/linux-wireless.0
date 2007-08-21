Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37120 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750742AbXHUEfJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 00:35:09 -0400
Subject: Re: [PATCHv3] mac80211: dynamic wep
From: Volker Braun <volker.braun@physik.hu-berlin.de>
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <20070821030559.GL1415@jm.kir.nu>
References: <1187151162.3253.18.camel@thinkpad>
	 <1187308221.23489.91.camel@johannes.berg>
	 <1187360200.4417.32.camel@thinkpad> <1187363345.6090.2.camel@johannes.berg>
	 <20070821030559.GL1415@jm.kir.nu>
Content-Type: text/plain
Date: Tue, 21 Aug 2007 00:35:06 -0400
Message-Id: <1187670906.3827.11.camel@thinkpad>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The APs rotate key index 1 and 2 for broadcast keys as you said, but
I've never seen it use anything but key index 3 for unicast keys. Key
index 0 is apparently never used. 

I understand that rekeying broadcast keys while all STA's exchange
broadcast traffic has a synchronization problem. But for unicast traffic
there is no way to lose packets during rekeying since at any given time
only one packet can be in the air. Am I missing something?





