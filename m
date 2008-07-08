Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4362 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757170AbYGHSiC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 14:38:02 -0400
Date: Tue, 8 Jul 2008 14:01:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Daniel Drake <dsd@gentoo.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] zd1211rw: ad-hoc connectivity
Message-ID: <20080708180132.GA17264@tuxdriver.com> (sfid-20080708_203815_041261_A424F3DB)
References: <20080704033117.4EDD872C001@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080704033117.4EDD872C001@zog.reactivated.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 04, 2008 at 04:31:17AM +0100, Daniel Drake wrote:
> Luis Carlos Cobo recently added beacon config code (to support mesh)
> which happens also to be most of the work needed to support ad-hoc.
> This patch does the rest.
> 
> Signed-off-by: Daniel Drake <dsd@gentoo.org>

This seems to overlap with this patch that is already in -next:

commit 84e6dc9acf6825f508feae9db6b7d695e64894e0
Author: Bruno Randolf <br1@einfach.org>
Date:   Wed May 7 11:46:02 2008 +0200

    zd1211rw: initial IBSS support
    
    this adds initial IBSS support for the zydas zd1211rw:
    convince driver that it can do IBSS mode. add mac80211 beacon_update callbac
    
    IBSS merge and TSF updates don't work yet, but it makes the driver usable in
    ad-hoc networks.
    
    Signed-off-by: Bruno Randolf <br1@einfach.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Yours might be better overall.  Perhaps you can reconcile with what
is already in the tree and resubmit?

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
