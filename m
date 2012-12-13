Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54487 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab2LMXQb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 18:16:31 -0500
Message-ID: <1355440612.9463.41.camel@jlt4.sipsolutions.net> (sfid-20121214_001634_600817_20F2E302)
Subject: Re: [RFC 2/2] cfg80211: check (VHT) bandwidth against regulatory
From: Johannes Berg <johannes@sipsolutions.net>
To: "Bitterli, Felix" <felixb@qca.qualcomm.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 14 Dec 2012 00:16:52 +0100
In-Reply-To: <40F35DA312B2CC468349B21A177FEE63382FC9A8@NASANEXD02E.na.qualcomm.com>
References: <1354812784-15845-1-git-send-email-johannes@sipsolutions.net>
	 <1354812784-15845-3-git-send-email-johannes@sipsolutions.net>
	 <CAB=NE6W=BAOwcQ_XjbDiySx7xvAFoutv96Kcc9ULujUAWDHMGA@mail.gmail.com>
	 <1355438841.9463.33.camel@jlt4.sipsolutions.net>
	,<CAB=NE6U8_YibHNu+rBP-rXUTnFom9N4gqck1R9-hK=g-OBBBRg@mail.gmail.com>
	 <40F35DA312B2CC468349B21A177FEE63382FC9A8@NASANEXD02E.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-13 at 23:13 +0000, Bitterli, Felix wrote:

> Pfft, yeah I have no clue yet. Felix would you know if there are any
> limitations hardware wise in theory at least of doing 80+80
> configurations (apart form what the standard would allow).

>  In case the two 80 are adjacent, it's called 160.

So basically you're saying in general, 80+80 adjacent aren't allowed.
I'll put in a check for that.

johannes

