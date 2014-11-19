Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41038 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932297AbaKSUm3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 15:42:29 -0500
Message-ID: <1416429744.9374.28.camel@sipsolutions.net> (sfid-20141119_214232_712831_43827E34)
Subject: Re: [PATCH] brcmfmac: don't include linux/unaligned/access_ok.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	John Linville <linville@tuxdriver.com>
Date: Wed, 19 Nov 2014 21:42:24 +0100
In-Reply-To: <546CFF4D.7010306@broadcom.com>
References: <1416428298-10000-1-git-send-email-johannes@sipsolutions.net>
	 <546CFF4D.7010306@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-11-19 at 21:36 +0100, Arend van Spriel wrote:
> On 11/19/14 21:18, Johannes Berg wrote:
> > From: Johannes Berg<johannes.berg@intel.com>
> >
> > This is a specific implementation,<asm/unaligned.h>  is the
> > multiplexer that has the arch-specific knowledge of which
> > of the implementations needs to be used, so include that.
> 
> Thanks, Johannes
> 
> Maybe it would be good to mention this was found by kbuild test robot.

Yeah, maybe. It was more or less by accident though :-)

John, in case I forget - I shouldn't send a mac80211-next pull request
before you merge this.

johannes

