Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49987 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759602Ab2FUNT5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 09:19:57 -0400
Message-ID: <1340284793.4489.19.camel@jlt3.sipsolutions.net> (sfid-20120621_151959_939401_593E35F1)
Subject: Re: [RFC v2] initial channel context implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 21 Jun 2012 15:19:53 +0200
In-Reply-To: <1340280216-18807-1-git-send-email-michal.kazior@tieto.com>
References: <1340280216-18807-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-21 at 14:03 +0200, Michal Kazior wrote:
> Hi,
> 
> Here's my respin of channel contexts patches. Thanks for the
> review on the previous version.

Looks pretty good to me, I'll follow up on the patches with some minor
comments.

> Changes in short:
> 
>  * renamed to chanctx (to avoid very_long_structure_names)
>  * pub/priv part added (and drv_priv)
>  * new mutex added
>  * channel contexts are a linked list
>  * tracing added
> 
> Next step would be to refactor mac80211 codepaths to take
> advantage of channel contexts (if used).

Sounds about right :)

johannes

