Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35116 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab2ECTBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 15:01:33 -0400
Message-ID: <1336071691.5167.10.camel@jlt3.sipsolutions.net> (sfid-20120503_210135_448118_2509DC31)
Subject: Re: [PATCH] mac80211: Adds clean sdata helper
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 03 May 2012 21:01:31 +0200
In-Reply-To: <1335266308-3286-1-git-send-email-Andrei.Emeltchenko.news@gmail.com> (sfid-20120424_131807_192899_819D1A2C)
References: <1335266308-3286-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	 (sfid-20120424_131807_192899_819D1A2C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks fine to me, but I'd prefer not having the mesh.h change, maybe we
can add an extra  if (ieee80211_vif_is_mesh(&sdata->vif)) or use if
instead of switch?

johannes


