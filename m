Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33887 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab0LGOPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 09:15:07 -0500
Date: Tue, 7 Dec 2010 09:01:21 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: Use capabilities information for the number of TX
 queues
Message-ID: <20101207140120.GA2700@tuxdriver.com>
References: <20101207020812.17506.40803.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101207020812.17506.40803.stgit@localhost6.localdomain6>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 07, 2010 at 11:08:12AM +0900, Bruno Randolf wrote:
> One thing I missed in my WME series: Older hardware does not have enough
> hardware queues to support WME. In this case we just set up one data queue. Use
> the capability information to decide how many queues to set up.
> 
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> 
> --
> 
> resend, seems like it got lost somewhere in a queue ;)

Did you originally post with a different subject?  The MARC archive
doesn't seem to see any prior posting.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
