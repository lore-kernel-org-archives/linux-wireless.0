Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41677 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135AbaLBST2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:19:28 -0500
Date: Tue, 2 Dec 2014 19:19:26 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] cfg80211: don't WARN about two consecutive Country IE
	hint
Message-ID: <20141202181926.GN25677@wotan.suse.de> (sfid-20141202_191932_294051_724A2163)
References: <1417506805-20361-1-git-send-email-emmanuel.grumbach@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1417506805-20361-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 02, 2014 at 09:53:25AM +0200, Emmanuel Grumbach wrote:
> This can happen and there is no point in added more
> detection code lower in the stack. Catching these in one
> single point (cfg80211) is enough. Stop WARNING about this
> case.
> 
> This fixes:
> https://bugzilla.kernel.org/show_bug.cgi?id=89001
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 2f1c6c572d7b ("cfg80211: process non country IE conflicting first")
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@suse.com>

  Luis
