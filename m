Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:37051 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbZISWbW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Sep 2009 18:31:22 -0400
Date: Sat, 19 Sep 2009 23:31:15 +0100
From: Andrew Price <andy@andrewprice.me.uk>
To: Sedat Dilek <sedat.dilek@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Problem with "cfg80211: fix SME connect" (bisected)
Message-ID: <20090919223114.GA3245@plato.andrewprice.me.uk>
References: <20090919220805.GA2728@plato.andrewprice.me.uk>
 <2d0a357f0909191512o2ad20b1ag3eb344948351cae3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2d0a357f0909191512o2ad20b1ag3eb344948351cae3@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 20, 2009 at 12:12:56AM +0200, Sedat Dilek wrote:
> Can you try "[PATCH] cfg80211: don't overwrite privacy setting" from [1]?
> 
> -Sedat
> 
> [1] http://marc.info/?l=linux-wireless&m=125323296617306&w=2

That fixes it, thanks.

Andrew
