Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47874 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbbBYT3x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 14:29:53 -0500
Message-ID: <1424892579.2050.31.camel@sipsolutions.net> (sfid-20150225_202956_902091_92445DDE)
Subject: Re: Question on tx-power and number of chains.
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 25 Feb 2015 20:29:39 +0100
In-Reply-To: <54EE20C9.3080006@broadcom.com>
References: <54EE19B5.9040807@candelatech.com>
		 (sfid-20150225_195138_688914_DE56C6F2) <1424891437.2050.29.camel@sipsolutions.net>
	 <54EE20C9.3080006@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-02-25 at 20:21 +0100, Arend van Spriel wrote:
> On 02/25/15 20:10, Johannes Berg wrote:
> > On Wed, 2015-02-25 at 10:51 -0800, Ben Greear wrote:
> >
> >> Is there a table somewhere that explains how many chains are used by each
> >> rate?
> >
> > mcsindex.com?
> 
> Nice. Adding that to my bookmarks. What happened to that quirky MCS32.

It's the unloved stepchild ;-)

They also removed all the other higher HT ones (>32) when adding VHT.
You can still find an old version on archive.org IIRC.

johannes

