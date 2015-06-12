Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:35787 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbbFLWdy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 18:33:54 -0400
Received: by iesa3 with SMTP id a3so32447703ies.2
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2015 15:33:53 -0700 (PDT)
Date: Fri, 12 Jun 2015 18:33:50 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jesse Jones <jjones@cococorp.com>,
	Alexis Green <agreen@cococorp.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix a NULL dereference in ath9k (and likely
 other drivers) when fixed mesh paths are used
Message-ID: <20150612223350.GA9006@localhost> (sfid-20150613_003358_174483_89777D14)
References: <CAAnMG+OgtSzFXqLOoZ-JbOr7xnexC3P0+M0fFLWTBtWru=4SKg@mail.gmail.com>
 <20150525161542.GA14318@localhost>
 <c305826859e4f12efb163463f7283d5a@mail.gmail.com>
 <1434139832.2679.38.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434139832.2679.38.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 12, 2015 at 10:10:32PM +0200, Johannes Berg wrote:
> On Fri, 2015-06-12 at 11:01 -0700, Jesse Jones wrote:
> 
> > I had trouble reproing the reboot caused by ath9k de-referencing NULL
> > pointers but after a fair amount of work I was able to consistently get
> > reboots. Your patch *does* fix the problem so I am going to switch our repo
> > over to your patch instead of what we were using. Thanks for the help.
> 
> Great. Bob, if it's no bother I'd appreciate if you'd resend the patch
> correctly so it gets picked up by patchwork etc.

Sure.  Jesse, want me to add your Tested-by?

-- 
Bob Copeland %% http://bobcopeland.com/
