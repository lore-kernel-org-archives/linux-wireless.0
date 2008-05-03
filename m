Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56102 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757495AbYECPio (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2008 11:38:44 -0400
Subject: Re: Please pull 'upstream' branch of rt2x00
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Scott White <nwi_sub@hotmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1209828478.3673.2.camel@johannes.berg>
References: <BAY113-W31BC1B2DB0F0597B99310784DA0@phx.gbl>
	 <200805031158.43072.IvDoorn@gmail.com> <1209809936.10921.9.camel@localhost>
	 <200805031702.20416.IvDoorn@gmail.com>
	 (sfid-20080503_165631_067313_B10C7019)  <1209828478.3673.2.camel@johannes.berg>
Content-Type: text/plain
Date: Sat, 03 May 2008 15:38:41 +0000
Message-Id: <1209829121.27386.1.camel@localhost> (sfid-20080503_173816_512141_186C40F8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-05-03 at 17:27 +0200, Johannes Berg wrote:
> > Hmm, perhaps we need some way the driver can inform the rate selection
> > module about statistics. I mean the hardware does measure the number
> > of failed TX frames, and the number of retries, but it doesn't set them
> > in the descriptor but in the hardware.
> 
> Yes we should have this.

New rate control algorithm probably. Or even better: Split what is
currently the rate control algorithm into an link quality estimation
part (failed frames percentage and such) and the actual rate control
that interprets that value and acts accordingly.

Mattias

