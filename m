Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:55778 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751531AbXLEJ5H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 04:57:07 -0500
Date: Wed, 5 Dec 2007 10:52:30 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	"Mattias Nissler" <mattias.nissler@gmx.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
Message-ID: <20071205105230.0ecc56dc@morte> (sfid-20071205_095711_342991_F57F4BE7)
In-Reply-To: <200712050849.46760.hs4233@mail.mn-solutions.de>
References: <1196622331.7472.4.camel@localhost>
	<20071204024146.15689ee3@morte>
	<40f31dec0712041405sb14243dw9ccb7509e6f58d8@mail.gmail.com>
	<200712050849.46760.hs4233@mail.mn-solutions.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 5 Dec 2007 08:49:46 +0100
Holger Schurig <hs4233@mail.mn-solutions.de> wrote:

> Or, in other words: if we put the AP 80m away and then try the 
> test, would the same PID parameters that yielded high MB/s rates 
> now still keep us a sane (for that distance!) connection?

Theoretically, a properly tuned PID controller should act well in both
scenarios. The problem here is that we need testing in worse scenarios. I
just detached the antenna from my AP, this decreases the signal level by
some 20-23dB. Will do some tests.


--
Ciao
Stefano
