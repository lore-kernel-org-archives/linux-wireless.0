Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43878 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab2KUIgd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 03:36:33 -0500
Message-ID: <1353487020.10444.2.camel@jlt4.sipsolutions.net> (sfid-20121121_093637_006019_D6ABD8E2)
Subject: Re: [PATCH 05/10] mac80211: convert to channel definition struct
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 21 Nov 2012 09:37:00 +0100
In-Reply-To: <1353481166.10872.197.camel@cumari.coelho.fi>
References: <1353447916-17304-1-git-send-email-johannes@sipsolutions.net>
	 <1353447916-17304-6-git-send-email-johannes@sipsolutions.net>
	 <1353481166.10872.197.camel@cumari.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-21 at 08:59 +0200, Luciano Coelho wrote:

> I guess these changes depend on something else that you have on your
> tree and is not in w-t yet, right? At least I couldn't find the
> definition of cfg80211_get_chandef_type().

For the record: it's in patch 4 :-)

johannes

