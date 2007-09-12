Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2200 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968596AbXILORb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2007 10:17:31 -0400
Date: Wed, 12 Sep 2007 09:43:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Cc: linux-wireless@vger.kernel.org, jt@hpl.hp.com,
	geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] remove duplicated ioctl entries in compat_ioctl.c
Message-ID: <20070912134312.GA6085@tuxdriver.com>
References: <20070730144726.GA6586@tuxdriver.com> <20070807153150.A867.MOKUNO@sm.sony.co.jp> <20070912133226.6818.MOKUNO@sm.sony.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070912133226.6818.MOKUNO@sm.sony.co.jp>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 12, 2007 at 01:36:16PM +0900, Masakazu Mokuno wrote:
> Hi John,
> 
> Could you please apply the patch that I has submitted in 8th Aug, for
> 2.6.24?
> 
> http://marc.info/?l=linux-wireless&m=118647249314475
> 
> This patch does not seem to be included into the wireless tree.

Well, thanks for pointing that out.  The reason is that the patch
was lost, probably due to the fact that it wasn't posted under a new
subject with something like "[PATCH] fix compat_ioctl blah blah blah".
I try to read every email and find all the patches, but this list does
get a lot of traffic.  If you could mark new patches more clearly it
would help me a lot.  Plus, it is probably easier than tracking the
trees and having to send reminders. :-)

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
