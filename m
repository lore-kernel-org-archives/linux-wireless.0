Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:48858 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab3EGP4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 11:56:38 -0400
Received: by mail-ie0-f176.google.com with SMTP id at1so1216935iec.7
        for <linux-wireless@vger.kernel.org>; Tue, 07 May 2013 08:56:38 -0700 (PDT)
Date: Tue, 7 May 2013 11:55:22 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Subject: Re: [RFC 01/12] mac80211: track and share mesh BSSes among
 interfaces
Message-ID: <20130507155522.GF1438@localhost> (sfid-20130507_175642_152446_5F03DBC7)
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
 <1367548442-8229-2-git-send-email-thomas@cozybit.com>
 <1367933862.8328.18.camel@jlt4.sipsolutions.net>
 <20130507140835.GD1438@localhost>
 <1367936535.8328.56.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1367936535.8328.56.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 07, 2013 at 04:22:15PM +0200, Johannes Berg wrote:
> But why even add it to the global list if you only need it locally?

Gotcha - agreed, makes sense to not do so and drop the can_share bit.

-- 
Bob Copeland %% www.bobcopeland.com
