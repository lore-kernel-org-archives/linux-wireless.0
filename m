Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34271 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab1ECOAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 10:00:54 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1QHG9j-0003vJ-3v
	for linux-wireless@vger.kernel.org; Tue, 03 May 2011 10:00:51 -0400
Received: from linville-8530p.local (linville-8530p.local [127.0.0.1])
	by linville-8530p.local (8.14.4/8.14.4) with ESMTP id p43Dl5HR003545
	for <linux-wireless@vger.kernel.org>; Tue, 3 May 2011 09:47:05 -0400
Received: (from linville@localhost)
	by linville-8530p.local (8.14.4/8.14.4/Submit) id p43Dl4Ot003543
	for linux-wireless@vger.kernel.org; Tue, 3 May 2011 09:47:04 -0400
Date: Tue, 3 May 2011 09:30:09 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: [davem@davemloft.net: net-2.6 state...]
Message-ID: <20110503133009.GA2467@tuxdriver.com> (sfid-20110503_160057_492572_4CAA65AF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FYI...obviously, this affects wireless-2.6 as well...

----- Forwarded message from David Miller <davem@davemloft.net> -----

> Date: Mon, 02 May 2011 15:20:44 -0700 (PDT)
> From: David Miller <davem@davemloft.net>
> To: netdev@vger.kernel.org
> Subject: net-2.6 state...
> X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
> 
> 
> Right now I'm sorting through patchwork to make sure anything that
> belongs in net-2.6, is there.
> 
> Then I'm going to push things out to Linus.
> 
> We will be in a more serious lock down mode after that.  So I really
> only want to see obvious critical fixes going into net-2.6.  Even
> comment typos will be put into net-next-2.6.
> 
> Please cooperate with this policy and everything will go smoothly.
> 
> There is nothing I like more than seeing people work on bug fixes at
> this point in the -rc* series, so if you want to make me (as well as
> the users reporting these things) really happy, fix some bugs. :-)
> 
> Thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

----- End forwarded message -----

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
