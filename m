Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from psionic.psi5.com ([212.112.229.180]:42024 "EHLO
	psionic8.psi5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab0GMFWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jul 2010 01:22:44 -0400
Date: Tue, 13 Jul 2010 07:14:30 +0200
From: Simon Richter <sjr@debian.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ben Hutchings <ben@decadent.org.uk>, Michael Buesch <mb@bu3sch.de>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org, 588196@bugs.debian.org
Subject: Re: Bug#588196: b43: does not join multicast groups
Message-ID: <20100713051430.GA2625@honey.hogyros.de>
References: <20100706021937.11147.78230.reportbug@debian.hogyros.de>
 <1278887148.6139.91.camel@localhost>
 <4C3A4C6E.6060801@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C3A4C6E.6060801@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sun, Jul 11, 2010 at 05:57:50PM -0500, Larry Finger wrote:

> When you get the FATAL DMA error, the controller is reset; however,
> that is just a simple work around that does not work on all systems.
> To get your system to work, you need to load b43 with the following
> options: pio=1 qos=0 nohwcrypy=1

That appears to work, at least I have v6 addresses now.

Thanks,
   Simon
