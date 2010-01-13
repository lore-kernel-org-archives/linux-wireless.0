Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out11.libero.it ([212.52.84.111]:55488 "EHLO
	cp-out11.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab0AMVpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2010 16:45:52 -0500
From: Fabio Rossi <rossi.f@inwind.it>
To: linux-wireless@vger.kernel.org
Subject: Re: ath5k: 2.6.32-rc6 "no further txbuf available, dropping packet"
Date: Wed, 13 Jan 2010 22:28:47 +0100
Cc: Bob Copeland <me@bobcopeland.com>,
	Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
	ath5k-devel@lists.ath5k.org
References: <4AF99EF9.4040408@nets.rwth-aachen.de> <201001120119.38062.rossi.f@inwind.it> <b6c5339f1001120835p381b440fgc2b30369737e104c@mail.gmail.com>
In-Reply-To: <b6c5339f1001120835p381b440fgc2b30369737e104c@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201001132228.47730.rossi.f@inwind.it>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 12 January 2010 17:35:04 Bob Copeland wrote:

> Ok, well then at least we know that it is working :)  Do you get any ill
>  effects besides the log spam?  If so then there could be an issue with
>  starvation of the processing tasklet.  Or maybe we should look at changing
>  the limits for better flow.

I don't have problems with the connection but sometimes it's seems less 
responsive, for instance it seems the latency in loading the web pages is 
longer. Of course this is a personal impression.

I'm available to test any patches if you think the behavior may be improved, 
also simply to investigate more on the issue.

Fabio
