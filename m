Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:32930 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935822Ab3BOMnB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 07:43:01 -0500
Received: by mail-ie0-f175.google.com with SMTP id c12so4605863ieb.20
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2013 04:43:00 -0800 (PST)
Date: Fri, 15 Feb 2013 07:42:55 -0500
From: Bob Copeland <me@bobcopeland.com>
To: devel@lists.open80211s.org
Cc: Marco Porsch <marco@cozybit.com>, vthiagar@qca.qualcomm.com,
	jouni@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	mcgrof@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	senthilb@qca.qualcomm.com, johannes@sipsolutions.net
Subject: Re: [PATCH 1/3] mac80211: move mesh sync beacon handler into
 neighbour_update
Message-ID: <20130215124255.GB3493@localhost> (sfid-20130215_134309_767289_4F73C7AF)
References: <1360928446-543-1-git-send-email-marco@cozybit.com>
 <1360930499.15040.7.camel@jlt4.sipsolutions.net>
 <20130215124046.GA3493@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130215124046.GA3493@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 15, 2013 at 07:40:46AM -0500, Bob Copeland wrote:
> > I don't think you should drop this comment; also why not just address
> > it? There's a timestamp in rx_status that should be the correct one for
> > ath9k (which is pretty much all this seems to work on anyway :) )
> 
> The comment is just moved?  Mesh already uses rx_status->mactime, if
> the driver supplies it, which the comment says :)

Oh I see - you are saying not to drop the comment about rcu locking.

-- 
Bob Copeland %% www.bobcopeland.com
