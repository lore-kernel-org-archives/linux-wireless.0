Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.xplot.org ([66.92.66.146]:35227 "EHLO www.xplot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab2KGQdt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 11:33:49 -0500
From: Tim Shepard <shep@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Daniel Drake <dsd@laptop.org>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	John Rhodes <jrhodes@marvell.com>
Subject: Re: [PATCH] mwifiex: add support for SDIO card reset 
In-reply-to: Your message of Tue, 06 Nov 2012 20:35:48 -0800.
             <477F20668A386D41ADCC57781B1F7043083BBD66E3@SC-VEXCH1.marvell.com>
Date: Wed, 07 Nov 2012 11:33:44 -0500
Message-Id: <E1TW8ZV-0001zW-00@www.xplot.org> (sfid-20121107_173403_516363_55125224)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Bing,

Thanks, that looks like it might fix the total wedgeup problem I was
seeing on some suspends.

I will try to test this in the next few days.

However, I am limited in my ability to test this.  At best, I could
produce only a few such failures per day of testing, and that was with
the SDIO dev kit, not with our protype cards.  It seems to test this
directly and repeatedly I would have to have a modified version of the
firmware that would deliberately cause on command what is normally
only a sporadic failure.

I will also try to understand how this patch behaves in the context of
the rest of the driver.

			-Tim Shepard
			 shep@laptop.org
