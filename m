Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55918 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933110Ab3DIJrx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 05:47:53 -0400
Message-ID: <1365500869.8465.10.camel@jlt4.sipsolutions.net> (sfid-20130409_114800_082862_5BFF4EA2)
Subject: Re: [PATCH 2/6] mac80211: exclude multicast frames from BA
 accounting
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Date: Tue, 09 Apr 2013 11:47:49 +0200
In-Reply-To: <1365444377-9959-2-git-send-email-thomas@cozybit.com> (sfid-20130408_200803_746944_CA235B9A)
References: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
	 <1365444377-9959-2-git-send-email-thomas@cozybit.com>
	 (sfid-20130408_200803_746944_CA235B9A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Subject should probably say "reordering" rather than "accounting"

> Since multicast aggregation is not currently supported by
> mac80211, we can safely ignore them when reordering
> aggregate MPDUs.

Multicast may have a lower expectation of ordering than unicast, but is
this really the right thing to do? It seems better to just fix it?

johannes

