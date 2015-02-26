Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51346 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbbBZHr3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 02:47:29 -0500
Message-ID: <1424936845.1885.3.camel@sipsolutions.net> (sfid-20150226_084732_221337_D0E791CD)
Subject: Re: Question on tx-power and number of chains.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 26 Feb 2015 08:47:25 +0100
In-Reply-To: <54EE276A.6050006@candelatech.com>
References: <54EE19B5.9040807@candelatech.com>
	  (sfid-20150225_195138_688914_DE56C6F2) <1424891437.2050.29.camel@sipsolutions.net>
	 <54EE276A.6050006@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-02-25 at 11:50 -0800, Ben Greear wrote:
> On 02/25/2015 11:10 AM, Johannes Berg wrote:
> > On Wed, 2015-02-25 at 10:51 -0800, Ben Greear wrote:
> > 
> >> Is there a table somewhere that explains how many chains are used by each
> >> rate?
> > 
> > mcsindex.com?
> 
> What about OFDM and CCK.  Are those always 1 chain?

They're 1 stream at least, so only one chain is needed. I'm not entirely
sure you couldn't transmit them on multiple chains but I don't think
it'd make that much sense?

johannes

