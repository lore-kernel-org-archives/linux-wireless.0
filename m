Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37695 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab2LLSbw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 13:31:52 -0500
Date: Wed, 12 Dec 2012 13:19:05 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: Steev Klimaszewski <steev@genesi-usa.com>,
	Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	Dmitry Tarnyagin <abi.dmitryt@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
Message-ID: <20121212181905.GA1885@tuxdriver.com> (sfid-20121212_193157_149509_159B471D)
References: <1330720003-15866-1-git-send-email-dmitry.tarnyagin@stericsson.com>
 <CAMG6FYjYMqf9C15Bid3hAfzTcB=gEXq8RWRcM9n+HNtvckgVZQ@mail.gmail.com>
 <CAFED-jk84vKMRr_NDThMqhZrnXt6ddhViztitB_=M_nKbC6c8Q@mail.gmail.com>
 <CA+Bgp3N2gUDoey-cXV+4sN0q+2Jm7+rPcu776FMUWxaR4F0qwg@mail.gmail.com>
 <20120706201839.GE1879@tuxdriver.com>
 <20121211232311.GA9080@shaftnet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121211232311.GA9080@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 11, 2012 at 06:23:11PM -0500, Solomon Peachy wrote:

> > So anyway, it seems like a repost of the current version (i.e. with
> > Bob's fixes, etc) is in order?
> 
> I'll have to go back and see if any of those fixes are still relevant.
> 
> Anyway, let me know how I should proceed from here..

It looks like others are interacting with you on this, and you
are getting good feedback.  I have no problem with you being the
maintainer for this driver -- just get it into shape and post it.
As Kalle suggested, posting it in pieces for review is usually a
good idea.  A final merge patch could be posted as one single patch,
or in many cases I just combine them into a single patch myself at
the final merge.

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
