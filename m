Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:16833 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759268Ab0J1Xgj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 19:36:39 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 28 Oct 2010 16:36:28 -0700
Date: Thu, 28 Oct 2010 16:36:36 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Ben Greear <greearb@candelatech.com>
CC: "ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH] ath9k: Clear DMA addresses when buffers
 are freed.
Message-ID: <20101028233636.GB2985@tux>
References: <1287178199-7506-1-git-send-email-greearb@candelatech.com>
 <4CCA0848.7080001@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4CCA0848.7080001@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 28, 2010 at 04:33:28PM -0700, Ben Greear wrote:
> On 10/15/2010 02:29 PM, greearb@candelatech.com wrote:
> > From: Ben Greear<greearb@candelatech.com>
> >
> > Previous patches cleared the pointer to the SKB, but did not
> > clear the DMA addresses.  This patch moves the clear logic into
> > a method and makes sure that the DMA addresses are cleared as well.
> >
> > This does not obviously fix any bug, but may make it harder to
> > cause bugs in the future.
> 
> I wanted to follow up to see if there was any interest in this patch,
> as it received no comment and has not been accepted upstream.

I'd rather not introduce code unless you know
for sure its doing something useful.

 Luis
