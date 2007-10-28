Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:38676
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbXJ1Kta (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 06:49:30 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Change error message for failed rc module (was: possible bug in ssb/b43)
Date: Sun, 28 Oct 2007 11:48:50 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <4a55afb80710271456k6c3bbfeah879b67a91a3b8d41@mail.gmail.com> <200710280034.41942.mb@bu3sch.de> <1193568021.3966.15.camel@johannes.berg>
In-Reply-To: <1193568021.3966.15.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200710281148.50859.mb@bu3sch.de> (sfid-20071028_104931_978550_9A788E8B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 28 October 2007 11:40:21 Johannes Berg wrote:
> 
> > Please compile and load rc80211_simple.
> 
> rc80211_simple is so little code, can't we just compile it into mac80211
> module and make it configurable only for EMBEDDED?

Yep, great idea. Let's make this default.
I will do a patch.

-- 
Greetings Michael.
