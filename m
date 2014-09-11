Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55899 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbaIKKJQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 06:09:16 -0400
Message-ID: <1410430147.1825.9.camel@jlt4.sipsolutions.net> (sfid-20140911_120919_605348_D3B91BA8)
Subject: Re: [PATCH v2 1/2] mac80211: Unify rate statistic variables between
 Minstrel & Minstrel_HT
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@nbd.name, ikstream86@gmail.com
Date: Thu, 11 Sep 2014 12:09:07 +0200
In-Reply-To: <1410297734-21187-2-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1410297734-21187-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 <1410297734-21187-2-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-09-09 at 23:22 +0200, Thomas Huehn wrote:
> Minstrel and Mintrel_HT used there own structs to keep track of rate
> statistics. Unify those variables in struct minstrel_rate_states and
> move it to rc80211_minstrel.h for common usage. This is a clean-up
> patch to prepare Minstrel and Minstrel_HT codebase for upcoming TPC.

Applied, thanks Thomas & Felix.

johannes

