Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51739 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab2K3MTK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 07:19:10 -0500
Message-ID: <1354277973.10035.26.camel@jlt4.sipsolutions.net> (sfid-20121130_131914_180079_5D8C0920)
Subject: Re: [RFCv2 13/13] mac80211: mesh PS individually-addressed frame
 release
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, thomas@cozybit.com,
	linux-wireless@vger.kernel.org
Date: Fri, 30 Nov 2012 13:19:33 +0100
In-Reply-To: <1353701934-12752-14-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353701934-12752-14-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-23 at 12:18 -0800, Marco Porsch wrote:

> +/* RSPI */
> +#define IEEE80211_QOS_CTL_RSPI			0x0400

*NOW* you do this? HAHA.

Ok I'm going to skip this patch for now. This wasn't quite as painful as
the last review, but it's just too much for a single day.

Next time, in order to actually get something done, please compile &
test each single patch, not just the final result. Also, it'd be great
if you could split up the patch series into maybe two or three (maybe
cfg80211/mac80211?) ... it's pretty big.

johannes

