Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:45429 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750764AbXLDSoq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 13:44:46 -0500
Date: Tue, 4 Dec 2007 19:40:17 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
Message-ID: <20071204194017.080467d2@morte> (sfid-20071204_184455_699780_CEDFAAEE)
In-Reply-To: <1196793186.7472.14.camel@localhost>
References: <1196622331.7472.4.camel@localhost>
	<20071203041608.3af3b462@morte>
	<1196679780.7470.9.camel@localhost>
	<20071203125402.76562f26@morte>
	<1196683144.7470.14.camel@localhost>
	<20071203130602.49ab7234@morte>
	<40f31dec0712031442q51a658abwfde965dae3fb6b72@mail.gmail.com>
	<20071204024146.15689ee3@morte>
	<1196756103.7476.12.camel@localhost>
	<20071204110135.1835a57e@morte>
	<1196790047.7472.5.camel@localhost>
	<20071204185719.2eba303c@morte>
	<1196793186.7472.14.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 04 Dec 2007 19:33:06 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:

> This is fine with me, let's go ahead with this approach. I'll do some
> test runs tonight to further tune the parameters. I also intend to clean
> up the code a little.

Yes, good idea. I avoided to do this because I didn't want to post new
patches which included yours - didn't want to appear to be stealing or
anything.


-- 
Ciao
Stefano
