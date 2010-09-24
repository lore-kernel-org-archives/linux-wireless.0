Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44738 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab0IXJLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 05:11:13 -0400
Subject: Re: [RFC v2 1/3] mac80211: remove prepare_for_handlers sdata
 argument
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4C9BC41E.70804@candelatech.com>
References: <20100923193747.677517441@sipsolutions.net>
	 <20100923193818.656678519@sipsolutions.net>
	 <4C9BC41E.70804@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Sep 2010 11:11:09 +0200
Message-ID: <1285319469.3699.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-23 at 14:18 -0700, Ben Greear wrote:
> I applied these 3 patches and using two STA interfaces on ath9k
> appears to work fine.  I'll leave them in my tree and continue
> testing.

Thanks, I've also tested them with two AP interfaces and it works fine,
will be submitting them momentarily.

johannes

