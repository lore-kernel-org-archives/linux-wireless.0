Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50087 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab2GIVBL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 17:01:11 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1SoL4u-0002Wn-MX
	for linux-wireless@vger.kernel.org; Mon, 09 Jul 2012 17:01:08 -0400
Received: from linville-8530p.local (linville-8530p.local [127.0.0.1])
	by linville-8530p.local (8.14.5/8.14.4) with ESMTP id q69KkhEM000855
	for <linux-wireless@vger.kernel.org>; Mon, 9 Jul 2012 16:46:44 -0400
Received: (from linville@localhost)
	by linville-8530p.local (8.14.5/8.14.5/Submit) id q69Kkh2r000854
	for linux-wireless@vger.kernel.org; Mon, 9 Jul 2012 16:46:43 -0400
Date: Mon, 9 Jul 2012 16:46:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: wireless-next.git rebased as well...
Message-ID: <20120709204643.GG1348@tuxdriver.com> (sfid-20120709_230115_435310_064CF6F8)
References: <20120709184607.GC1348@tuxdriver.com>
 <20120709190317.GD1348@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120709190317.GD1348@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stupidly, I had speculatively pulled wireless.git into
wireless-next.git.  Having rebased one, now I have to rebase the
other...

In particular, I know that the NFC tree will be affected by this.
Other trees may be as well, particularly any with pending pull
requests that may have rebased on wireless-next in the past week or so.
Please be aware and adjust your trees now if possible.

Again, sorry for the confusion...

John

On Mon, Jul 09, 2012 at 03:03:18PM -0400, John W. Linville wrote:
> Actually, I took the opportunity to consolidate Thomas Huehn's two
> patches (one of which fixes the other).  So the actual base is from
> c9015b24 now.
> 
> Sorry for the added confusion...
> 
> On Mon, Jul 09, 2012 at 02:46:07PM -0400, John W. Linville wrote:
> > I had to drop a patch.  Everything up to 0a08adeb stays the same, so if
> > you don't already have that then you should still be able to just pull.
> > 
> > Sorry for the inconvenience!
> > 
> > John
> > -- 
> > John W. Linville		Someday the world will need a hero, and you
> > linville@tuxdriver.com			might be all we have.  Be ready.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
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
