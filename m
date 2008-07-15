Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:27973 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbYGOSU4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 14:20:56 -0400
To: "Dan Williams" <dcbw@redhat.com>
Cc: Nicolas Pitre <nico@cam.org>, Michael Buesch <mb@bu3sch.de>,
	Stefanik =?iso-8859-15?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Linux Wireless Mini-Summit -- Ottawa -- July 22, 2008
References: <20080709190915.GA8238@tuxdriver.com>
	<69e28c910807100912h30fcb57fpb4fb48b95c640f77@mail.gmail.com>
	<200807101815.27204.mb@bu3sch.de>
	<1216142191.6039.113.camel@localhost.localdomain>
	<alpine.LFD.1.10.0807151323570.12484@xanadu.home>
	<1216144711.13411.18.camel@localhost.localdomain>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 15 Jul 2008 21:20:06 +0300
In-Reply-To: <1216144711.13411.18.camel@localhost.localdomain> (ext Dan Williams's message of "Tue\, 15 Jul 2008 13\:58\:31 -0400")
Message-ID: <87bq0zau21.fsf@nokia.com> (sfid-20080715_202113_458368_B87B100B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Dan Williams" <dcbw@redhat.com> writes:

> Some of the issues with the current Marvell 83xx GPL drivers that have
> gotten out are (a) code style, (b) lots of commented out stuff that's
> never used, (c) OS abstraction that's unnecessary on Linux, (d) doesn't
> use mac80211, and (e) uses private ioctls.  

I think you just listed exactly the problems with all vendor WLAN
drivers. 

I think Intel is the only expection here. Is there anyone else?

> So hopefully you're writing a new 83xx driver from scratch :)

And it always seems that this is the only viable way to solve it :)

(dropping lkml and netdev from CC)

-- 
Kalle Valo
