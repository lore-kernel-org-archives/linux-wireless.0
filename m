Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:59748 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753341Ab2LEMcK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 07:32:10 -0500
Message-ID: <50BF3EC7.3000004@posedge.com> (sfid-20121205_133220_619556_381AB517)
Date: Wed, 05 Dec 2012 18:02:07 +0530
From: Chaitanya <chaitanyatk@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix the multiple warnings for budding chipsets
 without ampdu_action defined
References: <50BF3DBB.90000@posedge.com> <1354710644.9972.11.camel@jlt4.sipsolutions.net>
In-Reply-To: <1354710644.9972.11.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hmm..yes true i need to fix my environment.
But i just tested this patch manually and it worked.

Let me check this once again, will fix this and send it again.

Sorry for the trouble caused.


On Wednesday 05 December 2012 06:00 PM, Johannes Berg wrote:
> Hm, no tabs it seems, so this doesn't apply either.
>
> I'd just fix it myself for this simple a thing, but you'll probably
> eventually want to submit more complicated patches ...

