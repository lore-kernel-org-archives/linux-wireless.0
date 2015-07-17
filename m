Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:34546 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101AbbGQPNI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 11:13:08 -0400
Received: by iebmu5 with SMTP id mu5so78789383ieb.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2015 08:13:08 -0700 (PDT)
Date: Fri, 17 Jul 2015 11:13:03 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Subject: Re: [PATCH v3 5/5] mac80211: select an AID when creating new mesh
 STAs
Message-ID: <20150717151303.GB27553@localhost> (sfid-20150717_171313_517027_DE106FD7)
References: <1436877119-17577-1-git-send-email-me@bobcopeland.com>
 <1436877119-17577-6-git-send-email-me@bobcopeland.com>
 <1437140910.1933.25.camel@sipsolutions.net>
 <1437144483.1933.27.camel@sipsolutions.net>
 <1437144656.1933.28.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1437144656.1933.28.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 17, 2015 at 04:50:56PM +0200, Johannes Berg wrote:
> > Actually, I'm dropping this one (the 5th) as it broke all the wpa_s
> > mesh test cases. Perhaps wpa_s isn't assigning an AID and mac80211
> > needs a fallback?
> > 
> 
> Actually, it also fails without any of your patches, so I guess it's
> some other issue. I'll keep these and sort it out when I'm back.

Ok, thanks for the heads-up.  I ran them against wpa_s and didn't notice
any breakage, but will retest against your tree over the weekend.

-- 
Bob Copeland %% http://bobcopeland.com/
