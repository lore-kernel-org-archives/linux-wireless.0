Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44032 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab0J2NaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 09:30:09 -0400
Date: Fri, 29 Oct 2010 09:21:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k:  Clear DMA addresses when buffers are freed.
Message-ID: <20101029132113.GA2399@tuxdriver.com>
References: <1287178199-7506-1-git-send-email-greearb@candelatech.com>
 <4CCA0848.7080001@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4CCA0848.7080001@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 28, 2010 at 04:33:28PM -0700, Ben Greear wrote:
> On 10/15/2010 02:29 PM, greearb@candelatech.com wrote:
> >From: Ben Greear<greearb@candelatech.com>
> >
> >Previous patches cleared the pointer to the SKB, but did not
> >clear the DMA addresses.  This patch moves the clear logic into
> >a method and makes sure that the DMA addresses are cleared as well.
> >
> >This does not obviously fix any bug, but may make it harder to
> >cause bugs in the future.
> 
> I wanted to follow up to see if there was any interest in this patch,
> as it received no comment and has not been accepted upstream.
> 
> Thanks,
> Ben

The patch seems fine to me, but it isn't a fix and so isn't going
anywhere until wireless-next-2.6 opens again (i.e. after the merge
window closes).

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
