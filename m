Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:48521 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965644AbXHMJXr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 05:23:47 -0400
Message-ID: <46C0231F.5040605@warmcat.com>
Date: Mon, 13 Aug 2007 10:23:43 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH] hostapd: work with monitor interface
References: <1186992004.27916.53.camel@johannes.berg>
In-Reply-To: <1186992004.27916.53.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:

> Andy, feel free to lift the BPF code into your stuff. I've extended the
> radiotap parser to understand two more items, not sure if we want those
> in the kernel (the only thing we'd do with them is ignore). Actually,
> the two types I added are IEEE80211_RADIOTAP_TX_FLAGS and
> IEEE80211_RADIOTAP_DATA_RETRIES both of which we'll probably need for
> injection.

Wow impressive amount of ioctl calls going into the bit bucket there...

I will try to use your direct BPF programming and also dispense with
libpcap tonight, thanks for that.

> I spent about two days working on this. Not too bad, so also thanks to
> Andy and everybody else who was involved with the injection for that.

Good work done!

-Andy
