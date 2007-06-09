Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 91-65-240-14-dynip.superkabel.de ([91.65.240.14]:49954 "EHLO
	charon.n2.diac24.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbXFILtM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2007 07:49:12 -0400
Date: Sat, 9 Jun 2007 13:49:07 +0200
From: David Lamparter <lists@diac24.net>
To: Jouni Malinen <jkm@devicescape.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Atheros Turbo modes / API [was: nl80211]
Message-ID: <20070609114907.GC10836@charon.n2.diac24.net>
References: <1181380044.3566.11.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1181380044.3566.11.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +               case MODE_IEEE80211A:
> +               case MODE_ATHEROS_TURBO:
> +                       *phymode = NL80211_PHYMODE_A;
> 
> Are those Atheros Turbo modes actually useful these days in mac80211? If
> so we probably should support them in nl80211 too, but I don't really
> know, I guess Jouni is the only one who ever used them?
> 

Jouni? Is this (a) still in use, and (b) how should it be made available to
userspace? We could either add additional modes to nl80211_phymode -or- add
a NL80211_ATTR_ATHEROS_TURBO as boolean tag -or- plunge it into debugfs...


-David

