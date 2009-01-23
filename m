Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:40180 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751098AbZAWRLR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 12:11:17 -0500
Date: Fri, 23 Jan 2009 09:09:29 -0800
From: Greg KH <greg@kroah.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: stable@kernel.org, andrey@cozybit.com,
	linux-wireless@vger.kernel.org, Keir <keirlawson@gmail.com>
Subject: Re: [stable] ath5k mesh in 2.6.28?
Message-ID: <20090123170929.GA11662@kroah.com> (sfid-20090123_181121_462603_1373C86C)
References: <e27b78a40901230530h192a8030l6905089df2a5822d@mail.gmail.com> <b6c5339f0901230717h605d2fbaibda8b720c6191abf@mail.gmail.com> <e27b78a40901230725r4dc40975t8e4cb9f481df1702@mail.gmail.com> <20090123153305.M33802@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090123153305.M33802@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 23, 2009 at 11:26:15AM -0500, Bob Copeland wrote:
> Hi stable hackers,
> 
> Would you consider taking b706e65b40417e03c2451bb3f92488f3736843fa,
> "ath5k: fix mesh point operation" for 2.6.28-stable?  It's a new feature 
> compared to 2.6.27, so not a regression per se; however, ath5k advertises
> mesh support in wiphy->interface_modes but doesn't make good on that 
> promise when it comes to actually setting up such an interface.

Based on your patch, I don't have an objection to taking it for the next
2.6.28 release (will have to be after 2.6.28.2 comes out.)  I'll queue
it up for the next review cycle.

thanks,

greg k-h
