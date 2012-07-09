Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48690 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2GITS2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 15:18:28 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1SoJTY-0001qy-7A
	for linux-wireless@vger.kernel.org; Mon, 09 Jul 2012 15:18:28 -0400
Received: from linville-8530p.local (linville-8530p.local [127.0.0.1])
	by linville-8530p.local (8.14.5/8.14.4) with ESMTP id q69J3Ih4014900
	for <linux-wireless@vger.kernel.org>; Mon, 9 Jul 2012 15:03:19 -0400
Received: (from linville@localhost)
	by linville-8530p.local (8.14.5/8.14.5/Submit) id q69J3Ig0014899
	for linux-wireless@vger.kernel.org; Mon, 9 Jul 2012 15:03:18 -0400
Date: Mon, 9 Jul 2012 15:03:18 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: Re: wireless.git rebased from
 0a08adeb773cb6ed79b482c12bd45e37c2fa583b
Message-ID: <20120709190317.GD1348@tuxdriver.com> (sfid-20120709_211831_274010_FECE8BF1)
References: <20120709184607.GC1348@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120709184607.GC1348@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Actually, I took the opportunity to consolidate Thomas Huehn's two
patches (one of which fixes the other).  So the actual base is from
c9015b24 now.

Sorry for the added confusion...

On Mon, Jul 09, 2012 at 02:46:07PM -0400, John W. Linville wrote:
> I had to drop a patch.  Everything up to 0a08adeb stays the same, so if
> you don't already have that then you should still be able to just pull.
> 
> Sorry for the inconvenience!
> 
> John
> -- 
> John W. Linville		Someday the world will need a hero, and you
> linville@tuxdriver.com			might be all we have.  Be ready.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
