Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:32768 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751780AbYAYUI4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 15:08:56 -0500
From: David Brownell <david-b@pacbell.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH 00/14] RFC: Driver for Wireless RNDIS USB devices.
Date: Fri, 25 Jan 2008 12:08:49 -0800
Cc: linux-wireless@vger.kernel.org, bjd@jooz.net,
	netdev@vger.kernel.org
References: <20080120001342.25718.83669.stgit@fate.lan> <200801241719.14941.david-b@pacbell.net> <1201267224.7266.6.camel@localhost>
In-Reply-To: <1201267224.7266.6.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801251208.50006.david-b@pacbell.net> (sfid-20080125_200900_347197_A547B11A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 25 January 2008, Jussi Kivilinna wrote:
> On Thu, 2008-01-24 at 17:19 -0800, David Brownell wrote:
> > > 13. [rndis_host] blacklist known wireless RNDIS devices
> > 
> > That will be a headache over time though ... can't you just
> > let the probe succeed enough to recogize it's wireless (using
> > the media flag) and then bail, so the next driver can try?
> 
> Sure, that works too (but causes a little bit more message flood).

Excess messages can be dealt with, or at worst, ignored.

Thanks.

