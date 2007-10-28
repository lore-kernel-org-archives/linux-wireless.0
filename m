Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:54861
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbXJ1NWJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 09:22:09 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] mac80211: make simple rate control algorithm built-in
Date: Sun, 28 Oct 2007 14:21:43 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
References: <4a55afb80710271456k6c3bbfeah879b67a91a3b8d41@mail.gmail.com> <200710281148.50859.mb@bu3sch.de> <1193577464.5197.2.camel@johannes.berg>
In-Reply-To: <1193577464.5197.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710281421.43574.mb@bu3sch.de> (sfid-20071028_132211_858101_6B5B1F5A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 28 October 2007 14:17:44 Johannes Berg wrote:
> Too frequently people do not have module autoloading enabled
> or fail to install the rate control module correctly, hence
> their hardware probing fails due to no rate control algorithm
> being available. This makes the 'simple' algorithm built into
> the mac80211 module unless EMBEDDED is enabled in which case
> it can be disabled (eg. if the wanted driver requires another
> rate control algorithm.)
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Michael Buesch <mb@bu3sch.de>

-- 
Greetings Michael.
