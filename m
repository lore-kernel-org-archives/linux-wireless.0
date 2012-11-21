Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:59224 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab2KUIlF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 03:41:05 -0500
Message-ID: <1353487222.10872.202.camel@cumari.coelho.fi> (sfid-20121121_094109_625540_E9A46B9B)
Subject: Re: [PATCH 05/10] mac80211: convert to channel definition struct
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 21 Nov 2012 10:40:22 +0200
In-Reply-To: <1353487020.10444.2.camel@jlt4.sipsolutions.net>
References: <1353447916-17304-1-git-send-email-johannes@sipsolutions.net>
	 <1353447916-17304-6-git-send-email-johannes@sipsolutions.net>
	 <1353481166.10872.197.camel@cumari.coelho.fi>
	 <1353487020.10444.2.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-21 at 09:37 +0100, Johannes Berg wrote:
> On Wed, 2012-11-21 at 08:59 +0200, Luciano Coelho wrote:
> 
> > I guess these changes depend on something else that you have on your
> > tree and is not in w-t yet, right? At least I couldn't find the
> > definition of cfg80211_get_chandef_type().
> 
> For the record: it's in patch 4 :-)

Maybe I should have looked at the whole series and not only into the
patch that changed wlcore. :P

Too lazy at that time in the morning... heheh

--
Luca.

