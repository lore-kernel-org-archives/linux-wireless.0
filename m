Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab1HYFIy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 01:08:54 -0400
Subject: Re: [PATCH 2/2] mac80211: add uapsd_queues and max_sp params fields
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAB3XZEfH_WAVJNkbTeOYAg8GndkAQeg+q8pLgK32MQr++RqQRw@mail.gmail.com> (sfid-20110824_085842_253861_E55E56B1)
References: <1314099467-20464-1-git-send-email-eliad@wizery.com>
	 <1314099467-20464-2-git-send-email-eliad@wizery.com>
	 <ee2d58eb0311dee326623ee17d872926@secure.sipsolutions.net>
	 <CAB3XZEcqwZxYYEcVrHcnCwBBS-z505yOoy2y8PjGxRSsnZp8Uw@mail.gmail.com>
	 <25d525ade5d006352bd7615ba5c98aa1@secure.sipsolutions.net>
	 <CAB3XZEfH_WAVJNkbTeOYAg8GndkAQeg+q8pLgK32MQr++RqQRw@mail.gmail.com>
	 (sfid-20110824_085842_253861_E55E56B1)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Aug 2011 22:09:10 -0700
Message-ID: <1314248950.5054.46.camel@jlt3.sipsolutions.net> (sfid-20110825_070857_101471_398A7265)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-24 at 09:58 +0300, Eliad Peller wrote:

> Currently, hostapd just looks for the uapsd_advertisement_enabled config param.
> i guess we can add and require ap_uapsd capability (on a different
> patch?). but won't it break environments that use new supplicant with
> old drivers?

Don't think so, since no old drivers support uAPSD.

johannes

