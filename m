Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47060 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbaBJTUr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 14:20:47 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.82)
	(envelope-from <johannes@sipsolutions.net>)
	id 1WCwPN-0001O6-SQ
	for linux-wireless@vger.kernel.org; Mon, 10 Feb 2014 20:20:46 +0100
Message-ID: <1392060043.4128.37.camel@jlt4.sipsolutions.net> (sfid-20140210_202050_594107_FC8E5876)
Subject: moving the wiki
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 10 Feb 2014 20:20:43 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone,

There has been kernel.org infrastructure for wikis for a long time,
though IIRC it didn't exist back when we set up our current wiki.
However, it seems like a good idea to convert the wiki to the kernel.org
infrastructure. This has some obvious advantages (like https support)
and gets us better support for it, with hopefully less downtime.

As a consequence, we'll be doing the following:
 * Mark the current wiki read-only, to guarantee a stable conversion.
This
   shouldn't take all that long, but we'll have to see.
 * I'll keep the read-only wiki at http://wireless.sipsolutions.net/ for
a while,
   in case somebody needs history - you can also download page/history
snapshots.
 * As we have a LOT of dead accounts, I've decided to NOT migrate them.
You'll
   have to sign up again, but I couldn't convert notifications etc.
anyway, so
   you'd have to touch those regardless.
 * We'll also drop page history, converting that is a bit more difficult
and the
   history isn't all that interesting for most pages.
 * For now, I won't be converting the style/skin. If anybody has (or
knows
   someone with) experience skinning mediawiki, help would be welcome.

Obviously, another consequence is that the wiki markup will change
somewhat. Moin and Mediawiki aren't too far from each other (except for
table syntax), but there are some things that are different that you'll
have to get used to when editing.

I think/hope that all this can happen over the next few days. If there
are any concerns (other than "don't do it") let me know.

Wish me luck ;-)

johannes

