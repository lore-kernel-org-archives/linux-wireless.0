Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44715 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab1HXKUu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 06:20:50 -0400
Date: Wed, 24 Aug 2011 13:17:07 +0300
From: Dan Carpenter <error27@gmail.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "open list:BROADCOM SPECIFIC..." <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch -next] bcma: signedness bug in bcma_get_next_core()
Message-ID: <20110824101707.GA5975@shale.localdomain> (sfid-20110824_122054_476873_1A04E1F6)
References: <20110818133809.GG4786@shale.localdomain>
 <CACna6rzwxA=OzQQ_VknsSq8BXXoH8U=GpdfkRTBWjFSNSjwsAA@mail.gmail.com>
 <20110823191306.GK12248@shale.localdomain>
 <CACna6rwLrGa4LU2GOQ03w+t5FfrD+c1rdHki_Nu-3oPVninCJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rwLrGa4LU2GOQ03w+t5FfrD+c1rdHki_Nu-3oPVninCJg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 24, 2011 at 12:01:11PM +0200, Rafał Miłecki wrote:
> Dan, I asked you to use int in both: call and function declaration.
> I'm the author of that code, and I don't have anything against
> modifying that :)
> 
> I think int is used much more often that s32 for errors.
> 

No problem.  Should I make bcma_erom_get_mst_port() return 0 on
success while I'm at it?

regards,
dan carpenter

