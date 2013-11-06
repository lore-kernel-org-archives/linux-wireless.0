Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43043 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab3KFK0Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 05:26:25 -0500
Message-ID: <1383733582.14307.23.camel@jlt4.sipsolutions.net> (sfid-20131106_112628_296601_78A3DF2A)
Subject: Re: [PATCH 05/19] cfg80211: processing core regulatory hints on its
 own
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Nov 2013 11:26:22 +0100
In-Reply-To: <1383733459.14307.22.camel@jlt4.sipsolutions.net> (sfid-20131106_112427_311529_C5CE2025)
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
	 <1383671897-7746-6-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20131105_181722_813465_91E1B730) <1383733459.14307.22.camel@jlt4.sipsolutions.net>
	 (sfid-20131106_112427_311529_C5CE2025)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > +	switch (treatment) {
> 
> is used uninitialized here

And dropping this patch pretty much stopped me from applying all others,
so I now only applied patch 2 and 4.

johannes

