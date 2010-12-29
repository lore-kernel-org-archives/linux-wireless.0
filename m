Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:53929 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab0L2Cny (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 21:43:54 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PXm11-0004Oc-C6
	for linux-wireless@vger.kernel.org; Wed, 29 Dec 2010 03:43:51 +0100
Received: from bas1-woodbridge48-1176129448.dsl.bell.ca ([70.26.79.168])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 29 Dec 2010 03:43:51 +0100
Received: from weedy2887 by bas1-woodbridge48-1176129448.dsl.bell.ca with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 29 Dec 2010 03:43:51 +0100
To: linux-wireless@vger.kernel.org
From: Weedy <weedy2887@gmail.com>
Subject: Re: Compile error for the last week inside rtlwifi/base.c
Date: Wed, 29 Dec 2010 02:43:39 +0000 (UTC)
Message-ID: <loom.20101229T034155-409@post.gmane.org>
References: <loom.20101228T075242-208@post.gmane.org> <4D1A0EF1.8060509@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@...> writes:

> Older kernels used create_workqueue(), which is replaced by alloc_workqueue()
> If you really need the driver for RTL8192CE/RTL8188CE, then apply the patch
> shown below. If you do not need the driver, then disable it in the 
> configuration.
> 
> Larry

Actually I need RTL8192USB, I guess I need to wait more?

