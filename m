Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:34730 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZGRQIH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jul 2009 12:08:07 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: WARN_ON at minstrel_get_rate (include/net/mac80211.h:2111)
Date: Sat, 18 Jul 2009 18:08:04 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
References: <4A611FC0.9040507@lwfinger.net> <200907181433.47985.chunkeey@web.de> <4A61E436.9060808@lwfinger.net>
In-Reply-To: <4A61E436.9060808@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907181808.05142.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 18 July 2009 17:03:18 Larry Finger wrote:
> Christian Lamparter wrote:
> > If my memory serves my right some people have triggered the same WARN_ON
> > with the ath5k driver as well...
> > unfortunately, I didn't follow the thread and now I can't find it anymore.
anyone? Bob, Nick?

> Thanks for the patch. I'll let you know what happens.
I have my doubts. Do you still have the WARN_ON dump?
or at least which of the two functions are listed in the dump?
- rate_control_get_rate 
- rate_control_rate_init <- unlikely/really surprising

Regards,
	Chr
