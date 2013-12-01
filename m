Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:38493 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab3LALjR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Dec 2013 06:39:17 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21147.7863.597679.144982@gargle.gargle.HOWL> (sfid-20131201_123934_688719_12A0A2CE)
Date: Sun, 1 Dec 2013 17:04:15 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Drasko DRASKOVIC <drasko.draskovic@gmail.com>, j@w1.fi,
	"hostap\@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless@vger.kernel.org
Subject: Re: multi-wiphy (virtual radios that can be used with multiple
 channels)
In-Reply-To: <1385890789.4171.5.camel@jlt4.sipsolutions.net>
References: <CAEk6gTCqKgt9zX0Xs147GYfxDw2Ex-1NkG4KZ_m_pdf1M8eDLw@mail.gmail.com>
	<21146.33378.141904.187743@gargle.gargle.HOWL>
	<CAEk6gTBS=WKfmDpzhd7istgCFnxMOpqJJnr7PUwKQ=uHeS0cdw@mail.gmail.com>
	<21146.47199.25277.169624@gargle.gargle.HOWL>
	<1385890789.4171.5.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Technically, it's not. Multi-channel support will *not* imply that you
> are able to put an AP and a client interface on two different channels -
> the AP wouldn't work correctly due to being absent when the client
> interface is being handled.
> 
> I would recommend against a driver allowing such use case since there's
> no way to tell the user that it's a stupid idea.

I had P2P GO/Client in mind. I should have mentioned that.

Sujith
