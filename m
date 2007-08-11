Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:33702 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbXHKKU5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Aug 2007 06:20:57 -0400
Received: from adicia.telenet-ops.be (adicia.telenet-ops.be [195.130.132.56])
	by hoefnix.telenet-ops.be (Postfix) with ESMTP id B69B89C20B
	for <linux-wireless@vger.kernel.org>; Sat, 11 Aug 2007 12:20:56 +0200 (CEST)
Message-ID: <46BD8D7E.3050003@telenet.be>
Date: Sat, 11 Aug 2007 12:20:46 +0200
From: ian <ischram@telenet.be>
MIME-Version: 1.0
To: Christopher Bills <cpbills@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi losing AP...
References: <65a3c8300708102331t42ce4da5kf2e3fb4a105f2f80@mail.gmail.com>
In-Reply-To: <65a3c8300708102331t42ce4da5kf2e3fb4a105f2f80@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Christopher Bills wrote:
> i'm using iwlwifi 1.0.0-1 on a lenovo thinkpad x61, with the Intel
> 4965AGN wireless card. I'm using kernel 2.6.22.2 with mac80211 v8.0.2
> and from time to time i lose my connection to my Belkin (802.11b)

We are probably going to need more debug information.dmesg (with debug turned on)
when this happens?

Personally I loose connection very rarely too(once every few days),
haven't investigated further. Get a no PropeResp message, which should indicate
that the connection was idle for two seconds, and the AP didn't respond to the probe?
(guess upping IWL_ACTIVE_DWELL_TIME_24 might help in this situation)

> router. this can often be remedied by issuing the 'iwconfig wlan0
> essid <ssid>' command, but is rather irritating.
> 
> is this a known issue, and if so, is there some sort of work-around? i
> tried using mac80211 v9.0.4 but my kernel will not compile with that,
> if that is known to fix it.

There is a fix or two, between the versions, this problem used to be more common,
so I can't say it wont help. I'm using wireless-dev's mac80211.

> 
> thanks in advance,
> 
> chris
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
