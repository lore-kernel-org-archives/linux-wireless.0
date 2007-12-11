Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45794
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754539AbXLKALp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 19:11:45 -0500
Date: Mon, 10 Dec 2007 16:11:44 -0800 (PST)
Message-Id: <20071210.161144.190139513.davem@davemloft.net> (sfid-20071211_001158_369998_2FC7030F)
To: dcbw@redhat.com
Cc: jt@hpl.hp.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Subject: Re: [RFC PATCH] introduce WEXT scan capabilities
From: David Miller <davem@davemloft.net>
In-Reply-To: <1197307403.18585.10.camel@localhost.localdomain>
References: <1197223174.9149.60.camel@localhost.localdomain>
	<20071209.221048.187424680.davem@davemloft.net>
	<1197307403.18585.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Williams <dcbw@redhat.com>
Date: Mon, 10 Dec 2007 12:23:23 -0500

> Is this an unconditional NAK for any changes to WEXT?

Well, it is at least completely proven that you cannot
extend the structures without crapping all over random
areas of the stack space of the user application.

So at a minimum you're going to get NAKs for any patch
that does things that way.
