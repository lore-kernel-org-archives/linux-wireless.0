Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:59695 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbYI3NtJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 09:49:09 -0400
Date: Tue, 30 Sep 2008 16:48:06 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
Subject: Re: NL80211_CMD_GET_WIPHY reply doesn't fit into nl message buffer
Message-ID: <20080930134806.GK4853@jm.kir.nu> (sfid-20080930_154913_276404_51709655)
References: <48E0A65A.2060102@gmail.com> <1222682480.7064.16.camel@johannes.berg> <20080929102021.GE10429@jm.kir.nu> <1222683923.7064.18.camel@johannes.berg> <20080929163147.GC4853@jm.kir.nu> <1222706734.7064.40.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1222706734.7064.40.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 29, 2008 at 06:45:34PM +0200, Johannes Berg wrote:

> Probably depends on something about alignment or whatever, not sure. Or
> you have different hardware and the driver reports different things for
> different hw? Anyway, it shouldn't wait forever, and my patch fixes
> that.

I was unable to reproduce it and as far as I can tell, I have identical
hardware from the view point of which channels are supported. Anyway,
the cleanup/fix is reasonable regardless.

> I see you applied that, it should be ported to the wpa_supplicant driver
> too, I think.

Yes, done.

-- 
Jouni Malinen                                            PGP id EFC895FA
