Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38375 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761522AbYFZSXE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 14:23:04 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [Q] ath5k : doesn't support AP mode?
Date: Thu, 26 Jun 2008 20:22:38 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Stefanik =?iso-8859-15?q?G=E1bor?= <netrolller.3d@gmail.com>,
	cs010101@gmail.com, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <002901c8d737$e51bb2f0$3b0aa8c0@39fb6b6b6f434b3> <1214503739.3783.14.camel@johannes.berg> <1214504288.18039.12.camel@dv>
In-Reply-To: <1214504288.18039.12.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200806262022.38890.mb@bu3sch.de> (sfid-20080626_202318_868785_EA8A3242)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 26 June 2008 20:18:08 Pavel Roskin wrote:
> On Thu, 2008-06-26 at 20:08 +0200, Johannes Berg wrote:
> 
> > > I also suspect that certain fixed are needed only for 802.11g or 802.11b
> > > compliance, but not for the original 802.11 compliance.
> > > 
> > > Say, if we limit the rate to 1 Mbps, are there any issues that really
> > > make us non-compliant?
> > 
> > The fact that we cannot limit the rate like that that?
> 
> That shouldn't be hard to implement.

We are not going to work around the bugs, I guess.
I'd suggest to put the patch into wireless-testing only.

-- 
Greetings Michael.
