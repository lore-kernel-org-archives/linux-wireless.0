Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47417 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab0IPTol (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 15:44:41 -0400
Date: Thu, 16 Sep 2010 15:38:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/9] ath5: Add multiple queues / QoS support
Message-ID: <20100916193831.GF7221@tuxdriver.com>
References: <20100916095112.17637.17207.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100916095112.17637.17207.stgit@tt-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 16, 2010 at 06:51:13PM +0900, Bruno Randolf wrote:

> It is based on my last series ("PATCH 0/8] ath: Move key cache functions 
> to ath common") and Bobs reordered base.c ("ath5k: reorder base.c to remove 
> fwd decls"). Please let me know if you have any merge issues and i'll resend
> the whole series.

You will need to resend this one -- Bob's no longer applies.  I have
your 8-patch series applied (with one small fixup from where Felix
removed some capability flags.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
