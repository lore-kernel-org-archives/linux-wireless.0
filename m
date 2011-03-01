Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:39202 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643Ab1CAWBE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 17:01:04 -0500
Date: Tue, 1 Mar 2011 17:01:30 -0500
From: Greg KH <greg@kroah.com>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: linux-wireless@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH] staging: rtl8192e: Fix incorrect netif_stop_queue
 usage warning
Message-ID: <20110301220130.GA25594@kroah.com>
References: <1298964192-13074-1-git-send-email-ozan@pardus.org.tr>
 <20110301211523.GA19958@kroah.com>
 <4D6D688C.7090605@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4D6D688C.7090605@pardus.org.tr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 01, 2011 at 11:43:40PM +0200, Ozan Çağlayan wrote:
> On 01.03.2011 23:15, Greg KH wrote:
> >On Tue, Mar 01, 2011 at 09:23:12AM +0200, Ozan Çağlayan wrote:
> >>The TX queues are allocated inside register_netdev.
> >>It doesn't make any sense to stop the queue before
> >>allocation.
> >>
> >>Signed-off-by: Ozan Çağlayan<ozan@pardus.org.tr>
> >>---
> >>  drivers/staging/rtl8192e/r8192E_core.c |    1 -
> >>  1 files changed, 0 insertions(+), 1 deletions(-)
> >
> >This patch doesn't apply, what tree did you make it against?
> 
> hmm, weird it was on top of an up-to-date linux-2.6 tree.

That's why it doesn't apply, I need patches against the linux-next tree
for stuff to go into the .39 kernel version.  Care to rediff this
against that one and resend it?

thanks,

greg k-h
