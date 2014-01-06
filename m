Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52898 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbaAFUPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 15:15:35 -0500
Date: Mon, 6 Jan 2014 15:00:50 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Luciano Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz,
	sre@ring0.de, joni.lapilainen@gmail.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: [PATCH v2 00/16] wl1251 patches from linux-n900 tree
Message-ID: <20140106200050.GG10885@tuxdriver.com> (sfid-20140106_211558_084074_F7F47D77)
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
 <1386494714-21070-1-git-send-email-pali.rohar@gmail.com>
 <201312311047.30147@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <201312311047.30147@pali>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 31, 2013 at 10:47:29AM +0100, Pali Rohár wrote:
> On Sunday 08 December 2013 10:24:58 Pali Rohár wrote:
> > Hello, I'm sending wl1251 patches from linux-n900 tree [1] for
> > comments. More patches come from David's monitor & packet
> > injection work. Patches are tested with 3.12 rc5 kernel on
> > Nokia N900.
> > 
> > Second version contains new patch for fixing NULL pointer
> > dereference which sometimes cause kernel panic and fixes code
> > suggested by Pavel Machek.
 
> So far, there are no new comments for patches 01, 03-13 and 16. 
> Are there any other problems with that patches or can be accepted 
> for upstream?
 
They are probably fine to merge now.  Of course, I was still deleting
wl12xx patches when they were originally posted, so I'll need someone
to resend the patches to me...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
