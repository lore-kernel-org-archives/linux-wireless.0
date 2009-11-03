Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58514
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006AbZKCGtd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 01:49:33 -0500
Date: Mon, 02 Nov 2009 22:49:57 -0800 (PST)
Message-Id: <20091102.224957.32364226.davem@davemloft.net>
To: dmitry.torokhov@gmail.com
Cc: torvalds@linux-foundation.org, johannes@sipsolutions.net,
	linville@tuxdriver.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: Please consider reverting
 7d930bc33653d5592dc386a76a38f39c2e962344
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091103053156.GA3212@core.coreip.homeip.net>
References: <20091103053156.GA3212@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Mon, 2 Nov 2009 21:31:56 -0800

> Hi Linus,
> 
> It looks like
> 
> commit 7d930bc33653d5592dc386a76a38f39c2e962344
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Tue Oct 20 15:08:53 2009 +0900
 ...
> is causing oops on resume:

There is a fix for this in my tree and I'll push it to Linus
tonight.
