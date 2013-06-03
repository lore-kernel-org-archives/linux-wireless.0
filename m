Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53677 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab3FCPDi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 11:03:38 -0400
Message-ID: <1370271815.8227.20.camel@jlt4.sipsolutions.net> (sfid-20130603_170342_026674_798FBEE0)
Subject: Re: [PATCH v2] mac80211: set mesh formation field properly
From: Johannes Berg <johannes@sipsolutions.net>
To: Jacob Minshall <jacob@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Mon, 03 Jun 2013 17:03:35 +0200
In-Reply-To: <1369863156-26149-1-git-send-email-jacob@cozybit.com> (sfid-20130529_233243_330571_1727458B)
References: <1369863156-26149-1-git-send-email-jacob@cozybit.com>
	 (sfid-20130529_233243_330571_1727458B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-05-29 at 14:32 -0700, Jacob Minshall wrote:
> Cap max peerings at 63 in accordance with IEEE-2012 8.4.2.100.7.
> Triggers a beacon regeneration every time the number of peerings changes.
> Previously this would only happen if the "accepting peerings" bit changed.

Applied.

johannes

