Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45155 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757401Ab0KKBCM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 20:02:12 -0500
Subject: Re: ath5k/mac80211:  Reproducible deadlock with 64-stations.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CDB3F7E.1000107@candelatech.com>
References: <4CDB2488.4040802@candelatech.com>
	 <4CDB3F7E.1000107@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 17:03:35 -0800
Message-ID: <1289437415.3748.26.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-10 at 16:57 -0800, Ben Greear wrote:

> I think the attached trace might be more useful.  It shows
> the blocked tasks spammage that we saw in an earlier
> run.

Yeah but we already knew that these tasks were blocking, and where ...
nothing really new here. I don't see it, yet anyway.

johannes

