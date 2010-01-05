Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46141
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754657Ab0AEXzf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 18:55:35 -0500
Date: Tue, 05 Jan 2010 15:55:39 -0800 (PST)
Message-Id: <20100105.155539.138677861.davem@davemloft.net>
To: rossi.f@inwind.it
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: problem with 2.6.33-rc2 tagging
From: David Miller <davem@davemloft.net>
In-Reply-To: <201001060021.41202.rossi.f@inwind.it>
References: <201001060021.41202.rossi.f@inwind.it>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fabio Rossi <rossi.f@inwind.it>
Date: Wed, 6 Jan 2010 00:21:41 +0100

> it seems that the current wireless.git misses a tag for the 2.6.33-rc2 kernel.

This happens in my net-2.6 tree too, when we pull in upstream
we just pull in the origin's master branch and not all of the
tags.
