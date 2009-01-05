Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:38668 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbZAEWYj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 17:24:39 -0500
Received: by wf-out-1314.google.com with SMTP id 27so7812282wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 05 Jan 2009 14:24:38 -0800 (PST)
Message-ID: <b6c5339f0901051424q12d8fc14o8f20b62cfacc4e6e@mail.gmail.com> (sfid-20090105_232443_188965_90B0DB26)
Date: Mon, 5 Jan 2009 17:24:38 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: drivers returning wrong results from their _tx op
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Daniel Drake" <dsd@gentoo.org>,
	"Tomas Winkler" <tomasw@gmail.com>,
	"Javier Cardona" <javier@cozybit.com>, Chr <chunkeey@web.de>
In-Reply-To: <1231193264.3697.41.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1231193264.3697.41.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 5, 2009 at 5:07 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> spatch:
>
> @ r1 @
> identifier _tx, _ops;

spatch is very neat...

> First off: all those should return NETDEV_TX_OK/BUSY.
> ath5k: returns 0/-1

Can the kerneldoc for mac80211 ops structure document it?

I'll send a patch for ath5k unless someone beats me to it.

-- 
Bob Copeland %% www.bobcopeland.com
