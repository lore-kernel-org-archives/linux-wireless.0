Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34755 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab1ISNCD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 09:02:03 -0400
Received: by eya28 with SMTP id 28so1534873eya.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2011 06:02:01 -0700 (PDT)
From: Alexander Simon <an.alexsimon@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 2/3] mac80211: Add HT helper functions
Date: Mon, 19 Sep 2011 15:01:57 +0200
Message-ID: <4494789.uEd83VaQuB@alex-1> (sfid-20110919_150207_922929_31ED2283)
In-Reply-To: <1316436947.5995.23.camel@jlt3.sipsolutions.net>
References: <35635039ce7d4a79dc62b19d51ccf0d5d4838112.1316297595.git.an.alexsimon@googlemail.com> <1501100748f4096d10848f6eec03f22e96e35b8e.1316297595.git.an.alexsimon@googlemail.com> <1316436947.5995.23.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 19. September 2011, 14:55:47 schrieben Sie:
> On Sun, 2011-09-18 at 00:14 +0200, Alexander Simon wrote:
> > Some refactoring for IBSS HT.
> > 
> > Move HT info and capability IEs building code into separate functions.
> > 
> > Add function to get the channel type from an HT info IE.
> > 
> > +enum nl80211_channel_type
> > +ieee80211_ht_info_to_channel_type(struct ieee80211_ht_info *ht_info);
> 
> Did I miss it, or do you not use that function any more?
> 
> johannes
I use it in ieee80211_rx_bss_info, patch 3/3.

Alex
