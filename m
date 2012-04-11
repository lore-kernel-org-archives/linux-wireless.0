Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:50112 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab2DKCzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 22:55:10 -0400
Date: Tue, 10 Apr 2012 22:54:51 -0400 (EDT)
Message-Id: <20120410.225451.92022308007980352.davem@davemloft.net> (sfid-20120411_045516_030094_0041A3C8)
To: preining@logic.at
Cc: egrumbach@gmail.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
	ilw@linux.intel.com
Subject: Re: 3.4-rc2, ilwagn still most of the time completely unusable
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120411023747.GA10126@gamma.logic.tuwien.ac.at>
References: <20120330011734.GH6277@gamma.logic.tuwien.ac.at>
	<20120411023747.GA10126@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Norbert Preining <preining@logic.at>
Date: Wed, 11 Apr 2012 11:37:47 +0900

> Well, hope that in another 20 kernel revisions that might get fixed,
> we are not talking about a brand new wlan adapter anymore ... that
> was some years ago ... especially the regression from 2.6.38 where it
> was working without any problem to the current very sad state of affair
> is frustrating.

In those 20 kernel revisions you, or a party interested in helping
you, could have GIT bisected the guilty change which introduced
the problem.

Then we'd have something concrete to go on, and use to work towards a
fix.

Right now there isn't nearly enough information to fix the problem.
