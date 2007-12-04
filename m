Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:42369 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751434AbXLDRxA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 12:53:00 -0500
Date: Tue, 4 Dec 2007 18:48:39 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
Message-ID: <20071204184839.46eb3ad9@morte> (sfid-20071204_175303_578148_170EF8B0)
In-Reply-To: <1196775624.6060.52.camel@johannes.berg>
References: <1196622331.7472.4.camel@localhost>
	<20071203041608.3af3b462@morte>
	<1196679780.7470.9.camel@localhost>
	<1ba2fa240712030321g58b8df39y24240c63facba2cd@mail.gmail.com>
	<1196681514.7470.12.camel@localhost>
	<1196775624.6060.52.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 04 Dec 2007 14:40:23 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> If anybody's interested, here's what I'd do:
> 
>  (a) add new attributes "rate control algorithm" and "rate control
>      algorithm attributes"
>  (b) allow setting them with NL80211_CMD_SET_INTERFACE
>  (c) the "rate control algorithm attributes" attribute is nested and
>      contains per-algorithm information, the indexes in it are specific
>      to each algorithm
> 
> This allows changing the algorithm as well as algorithm parameters.

This sounds great to me. Anyway, I'm still not completely convinced that we
need to actually make any parameter available for 'rc80211-pid', but it's
likely anyway. And that would be needed very likely for other rate control
algorithm, so yes, I agree with this.


--
Ciao
Stefano
