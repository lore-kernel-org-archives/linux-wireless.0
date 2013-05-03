Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from a.mail.sonic.net ([64.142.16.245]:36211 "EHLO a.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934342Ab3ECUcA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 16:32:00 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] tcpdump: add STBC Rx support
From: Guy Harris <guy@alum.mit.edu>
In-Reply-To: <1367610836-3303-5-git-send-email-linux@rempel-privat.de>
Date: Fri, 3 May 2013 12:58:27 -0700
Cc: ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	radiotap@NetBSD.org
Message-Id: <15EBD372-C4E3-4DA3-9ED9-47B238654587@alum.mit.edu> (sfid-20130503_223214_100783_3AF0BB88)
References: <1367527479.11375.19.camel@jlt4.sipsolutions.net> <1367610836-3303-1-git-send-email-linux@rempel-privat.de> <1367610836-3303-5-git-send-email-linux@rempel-privat.de>
To: Oleksij Rempel <linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You might want to fork the tcpdump Git repository on GitHub:

	https://github.com/the-tcpdump-group/tcpdump

make your changes, and submit a pull request for the tcpdump repository; that's the preferred way to submit changes to tcpdump (and, *mutatis mutandis*, to libpcap).