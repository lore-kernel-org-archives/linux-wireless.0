Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2659 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757909AbXG3RmT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2007 13:42:19 -0400
Date: Mon, 30 Jul 2007 10:47:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Cc: linux-wireless@vger.kernel.org, jt@hpl.hp.com
Subject: Re: [PATCH] remove duplicated ioctl entries in compat_ioctl.c
Message-ID: <20070730144726.GA6586@tuxdriver.com>
References: <20070727191053.GA7572@tuxdriver.com> <20070727215847.GA17991@bougret.hpl.hp.com> <20070730145358.327D.MOKUNO@sm.sony.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070730145358.327D.MOKUNO@sm.sony.co.jp>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 30, 2007 at 09:02:56PM +0900, Masakazu Mokuno wrote:

> In second half of the mail, I understood the he asked how about keeping
> used one (COMPATIBLE_IOCTL) instead of HANDLE_IOCTL one, considering
> compatibilities.  As I can esteem the idea that sometimes the compatibilities
> are more important than changing something and I didn't think my patch
> could address all problems of the issue and I had much time to test more,
> I replied with the intention that I didn't stick to the patch if all
> userland application could work around perfectly.

Masakazu-san,

Thank you very much for your thorough explanation of the situation.
I apologize for having been a bit slow to grasp what you were doing.

I agree that the HANDLE_IOCTL version seems correct.  As you correctly
understood, my concern was that we not break anything new in the
process of fixing this bug.

Have you tested the both the old and the new wireless-tools on
a kernel with your patch applied?  Both 32- and 64-bit versions?
Do they all work equally well?

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
