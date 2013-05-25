Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:61994 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757624Ab3EYTDF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 May 2013 15:03:05 -0400
Received: by mail-lb0-f175.google.com with SMTP id v10so5583840lbd.6
        for <linux-wireless@vger.kernel.org>; Sat, 25 May 2013 12:03:03 -0700 (PDT)
Date: Sat, 25 May 2013 21:02:55 +0200 (CEST)
From: Thommy Jakobsson <thommyj@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	m@bues.ch, piotras@gmail.com, Larry.Finger@lwfinger.net,
	Thommy Jakobsson <thommyj@gmail.com>
Subject: Re: [PATCH] B43: Handle DMA RX descriptor underrun
In-Reply-To: <20130524164922.GA2175@tuxdriver.com>
Message-ID: <alpine.DEB.2.02.1305252058060.1282@kelly.ryd.net> (sfid-20130525_210322_856079_6F33810A)
References: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net> <CACna6rxWPOqQPNUaASaj=v=O+Wjt0okjX4jNwE3tv-=etfATCg@mail.gmail.com> <alpine.DEB.2.02.1305132025560.1278@kelly.ryd.net> <20130524164922.GA2175@tuxdriver.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 24 May 2013, John W. Linville wrote:

> Ping?  Should I drop this one?
> 
Still working great on my device, so from that I think we should go for 
it. But it would be great if Rafal (or someone) tested it on some other 
hardware as well. 

//Thommy
