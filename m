Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46201 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761782AbZDQSPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 14:15:48 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1LusbL-0007xZ-Vx
	for linux-wireless@vger.kernel.org; Fri, 17 Apr 2009 14:15:48 -0400
Received: from linville-t400.local (linville-t400.local [127.0.0.1])
	by linville-t400.local (8.14.3/8.14.3) with ESMTP id n3HI7uEf020135
	for <linux-wireless@vger.kernel.org>; Fri, 17 Apr 2009 14:07:56 -0400
Received: (from linville@localhost)
	by linville-t400.local (8.14.3/8.14.3/Submit) id n3HI7uL6020133
	for linux-wireless@vger.kernel.org; Fri, 17 Apr 2009 14:07:56 -0400
Date: Fri, 17 Apr 2009 14:07:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [ANN] wireless-regdb: master-2009-04-16
Message-ID: <20090417180755.GB3291@tuxdriver.com> (sfid-20090417_201602_903739_57515BBF)
References: <E1Luqjw-00028y-LQ@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <E1Luqjw-00028y-LQ@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

People are reporting that regdbdump is failing to verify the signature
on regulatory.bin with this update, so you may want to hold-off...

John

On Fri, Apr 17, 2009 at 06:16:32PM +0200, wireless@sipsolutions.net wrote:
> 
> A new release of wireless-regdb (master-2009-04-16) is available at:
> 
> http://wireless.kernel.org/download/wireless-regdb/wireless-regdb-2009.04.16.tar.bz2
> 
> SHA1 sum: 601001b97fe344fe64cdd3f9d0d80ddc9a729d02
> 
> 
> For your convenience the individual regulatory.bin file can be downloaded from:
> 
> http://wireless.kernel.org/download/wireless-regdb/regulatory.bins/2009.04.16-regulatory.bin
> 
> SHA1 sum eb35dd05a1d9a212fc76ef56f4da9bcdc59ba64a
> 
> Here is the short log of the changes included in this 
> release:
> 
> John W. Linville -  wireless-regdb: update regulatory.bin based on preceding changes.
> Luis R. Rodriguez -  wireless-regdb: fix a couple of comment typos
> Luis R. Rodriguez -  wireless-regdb: make distribution packaging easier
> Luis R. Rodriguez -  wireless-regdb: KR few reg updates
> Luis R. Rodriguez -  wireless-regdb: BN was missing two 5 GHz bands
> Johannes Berg -  update/fix DE 5GHz rules
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
