Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sidious.london.02.net ([82.132.130.152]:40919 "EHLO
	mail.o2.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752222Ab1CFWEm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 17:04:42 -0500
Date: Sun, 6 Mar 2011 22:04:37 +0000
From: Tony Houghton <h@realh.co.uk>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jmalinen@atheros.com>,
	Jonathan Nieder <jrnieder@gmail.com>,
	ath9k-devel@lists.ath9k.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil@venema.h4ckr.net, Vivek Natarajan <vnatarajan@atheros.com>
Subject: Re: [ath9k-devel] ath9k causes lockups since kernel 2.6.35
Message-ID: <20110306220437.63f7f4ea@realh.co.uk>
In-Reply-To: <AANLkTikjQPVjkHZy29B9e=jgOyH__HB0ED0aSQALEc2t@mail.gmail.com>
References: <20110224182022.57e32862@toddler>
	<20110224200203.GB17412@elie>
	<AANLkTiksoeKhMaFarSDVCbcDbZx6iWHkYzrg--1NcKKA@mail.gmail.com>
	<20110225144718.63550601@realh.co.uk>
	<AANLkTinu9NgnZZmieh2PU6e-iShOkapV9kcVe8YGtPHG@mail.gmail.com>
	<20110225165745.4860afe0@realh.co.uk>
	<20110226183542.75bc1786@realh.co.uk>
	<AANLkTi=ZWmWZWMBSdGX8S9EfiRyv3eKEU9P3n0bfDAuJ@mail.gmail.com>
	<20110302163051.425d1419@toddler>
	<AANLkTinEA2NVxwWZJME-oChE6OEJc_TSTajMfe7f+3hm@mail.gmail.com>
	<20110303143151.03dbe76b@toddler>
	<AANLkTiksdt5fciyFZ_nphEYgLH6Ey_HSHHpY5Eg9pNqD@mail.gmail.com>
	<20110303191656.73bba824@realh.co.uk>
	<AANLkTikjQPVjkHZy29B9e=jgOyH__HB0ED0aSQALEc2t@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 4 Mar 2011 21:20:02 +0530
Mohammed Shafi <shafi.wireless@gmail.com> wrote:

> 2011/3/4 Tony Houghton <h@realh.co.uk>:  
> >
> > I also found that I couldn't reproduce the problem while running on
> > battery, but as soon as I connected the PSU it crashed the very next
> > time I disabled wireless. I hadn't noticed that PSU/battery made a
> > difference before, but it does seem to be an issue.
> >  
> 
> Please see whether this is consistently reproducible.  

No, today it crashed on battery power. Something else must have been
different too when I tried on battery before, because I restarted the
wireless several times without problem, and usually it crashes almost
every time.

> As a try can you please disable the network manager and use iw command
> to connect?  

I tried wicd early on, that crashed too.
