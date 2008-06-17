Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:38372 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbYFQRWx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 13:22:53 -0400
Received: by py-out-1112.google.com with SMTP id p76so2282323pyb.10
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jun 2008 10:22:52 -0700 (PDT)
Subject: Re: [RFC PATCH 3/7] 802.11w: Add BIP (AES-128-CMAC)
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <1213721714.3803.83.camel@johannes.berg>
References: <20080617154008.883383150@localhost>
	 <20080617155904.082926456@localhost>
	 <1213721714.3803.83.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 17 Jun 2008 10:22:49 -0700
Message-Id: <1213723369.2125.4.camel@brick> (sfid-20080617_192256_626458_2167AB96)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-06-17 at 18:55 +0200, Johannes Berg wrote:

> > +	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT)
> > +		return RX_CONTINUE;
> 
> Harvey just added a bunch of helper inlines to include/linux/ieee80211.h
> for stuff like that, I think you could use one of them here.

Afraid not, rx->fc is a u16.  The helpers are all for __le16.

Harvey

