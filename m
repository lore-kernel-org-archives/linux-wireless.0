Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38957 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab3CCUfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Mar 2013 15:35:52 -0500
Message-ID: <1362342943.8226.3.camel@jlt4.sipsolutions.net> (sfid-20130303_213603_969256_9121AFFF)
Subject: Re: [PATCH 05/13] brcmfmac: only do auth_type workaround when no
 WPA or RSN IE is provided
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Sun, 03 Mar 2013 21:35:43 +0100
In-Reply-To: <5133A8D2.9090100@broadcom.com>
References: <1362311132-29561-1-git-send-email-arend@broadcom.com>
	 <1362311132-29561-6-git-send-email-arend@broadcom.com>
	 ( sfid-20130303_124611_530276_DB95CBBF) <1362331252.8226.2.camel@jlt4.sipsolutions.net>
	 <5133A8D2.9090100@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-03-03 at 20:47 +0100, Arend van Spriel wrote:
> On 03/03/13 18:20, Johannes Berg wrote:
> > On Sun, 2013-03-03 at 12:45 +0100, Arend van Spriel wrote:
> >> The workaround is only needed when auth_type is automatic AND there is
> >> no WPA or RSN information element provided by cfg80211.
> >
> > Does this really actually happen? Why would wpa_s select automatic when
> > it knows it's going to be open?
> >

> You are right and it does not happen with wpa_s. However, it does 
> 'actually really happen' :-) 

:-)
Just curious.

> when using iw to connect to an unsecure AP.

Right but then checking for RSN/WPA won't make a difference? I guess I
don't really understand the code, so you better ignore me ;-)

johannes

