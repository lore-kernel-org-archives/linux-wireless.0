Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54549 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073Ab0HNMSg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Aug 2010 08:18:36 -0400
Subject: Re: cfg80211 support for pre-auth
From: Johannes Berg <johannes@sipsolutions.net>
To: Dhiraj Gaurh <dhiraj.gaurh@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTin1=7JDXSJgTQ-L-9-r18VJY1fUVLPY+cPup8Pn@mail.gmail.com>
References: <AANLkTin1=7JDXSJgTQ-L-9-r18VJY1fUVLPY+cPup8Pn@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 Aug 2010 14:18:31 +0200
Message-ID: <1281788311.3984.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, 2010-08-13 at 20:10 +0530, Dhiraj Gaurh wrote:
> Hello folks,
>  PMK caching and pre-auth are not currently supported by
> cfg80211/nl80211/supplicant. Actually the former is only not supported
> by wpa_supplicant. I have fixed that and will be moving the code
> upstream shortly.

Sounds good.

> BUT the latter is not even supported by cfg/nl. Anybody working on
> that ? Actually support is not even there for using wext in this
> scenario. So you just fail certification if you use cfg/nl. I need to
> change this scenario.
> Currently thinking if it is better to add support in cfg/nl/supplicant
> or just use wext stuff and a patch.
> I need an API in cfg80211 to let the driver tell cfg that it has got
> beacon from another AP it can preauth with. Then the supplicant will
> start the pre-auth process when it receives the message.

I don't get it. You have the information, it's part of the scan results,
quite obviously. Roaming, and consequently pre-authentication, isn't
triggered by the driver. Or are you thinking about full-mac scenarios?

johannes

