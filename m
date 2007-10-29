Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3327 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbXJ2VHh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 17:07:37 -0400
Date: Mon, 29 Oct 2007 17:06:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi,
	akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] hostap: fix section mismatch warning
Message-ID: <20071029210620.GB27547@tuxdriver.com> (sfid-20071029_210740_586227_821F2BF1)
References: <20071029112026.f66473c5.randy.dunlap@oracle.com> <20071029205254.GA27547@tuxdriver.com> <4726497F.2010709@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4726497F.2010709@oracle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 29, 2007 at 01:58:39PM -0700, Randy Dunlap wrote:

> >Would you mind explaining how changing the name of the pci_driver
> >variable resolves this?  There must be some magic here...
> 
> Oh, sure.  In scripts/mod/modpost.c, there is a whitelist of variable
> name suffixes.  Those suffixes are assumed to be safe for referring
> to non-text code/data.  OTOH, if someone complains enough, another
> whitelist table element can also be added...

Ah, got it.  Thanks!

John
-- 
John W. Linville
linville@tuxdriver.com
