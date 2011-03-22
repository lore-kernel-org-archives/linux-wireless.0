Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38792 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab1CVNhM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2011 09:37:12 -0400
Subject: Re: [PATCH 0/4] Add station BSS parameters to station
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20110321213812.76CD420891@glenhelen.mtv.corp.google.com>
References: <20110321213812.76CD420891@glenhelen.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Mar 2011 14:37:10 +0100
Message-ID: <1300801030.3746.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-21 at 14:32 -0700, Paul Stewart wrote:

> Paul Stewart (4):
>   nl80211: Add station info flags and intervals
>   cfg80211: Add station info to station struct
>   nl80211: Add bss info to station message
>   mac80211: Add bss info to that exported to station

Also, FWIW, I wouldn't mind if the first three patches were rolled up
into one, or even all of them for such a fairly simple thing. Not saying
you need to change it either though.

johannes

