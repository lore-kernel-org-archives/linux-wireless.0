Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:14643 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab0ATHcq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 02:32:46 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] cfg80211: add a callback for querying the operating frequency and export it through nl80211
Date: Wed, 20 Jan 2010 08:32:48 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>
References: <4B536B05.6070301@openwrt.org> <4B537A94.9070807@openwrt.org> <1263762351.28067.21.camel@johannes.local>
In-Reply-To: <1263762351.28067.21.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <201001200832.48698.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> In any case I have a feeling you're trying to use the kernel as
> a database for something you already know, just don't have
> quite as readily available as you'd like.

I have a device where the current channel is shown to user-space, 
e.g. the operator. We used that to find out on what channel the
current AP is. Or, when the channel is constantly changing, that 
the system is still searching for a matching access-point.

I know that for both things there are other ways to query the 
same information, but it's convenient nethertheless.


But one thing for which is no other way is to see the actual 
channel-changes due to the search for a new AP. If such a thing 
would be important (it isn't for me), maybe a nl80211 broadcast 
would be better than, thought.

-- 
http://www.holgerschurig.de
