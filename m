Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:38884 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754788AbaCSIfe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 04:35:34 -0400
Message-ID: <1395218106.2854.0.camel@dubbel> (sfid-20140319_093538_893433_680E75B8)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Date: Wed, 19 Mar 2014 10:35:06 +0200
In-Reply-To: <1395217729-13565-1-git-send-email-johannes@sipsolutions.net>
References: <1395217729-13565-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v2] mac80211: verify deauthentication and return error
 on failure
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-03-19 at 09:28 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When still authenticating the mac80211 code handling a deauthentication
> requests from userspace doesn't verify that the request is valid in any
> way, fix that. Additionally, it never returns an error, even if there's
> no connection or authentication attempt, fix that as well.
> 
> While at it, move the message to not print a message in the error case
> and to distinguish between the two cases.
> 
> Also simplify the code by duplicating the cfg80211 call.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>


