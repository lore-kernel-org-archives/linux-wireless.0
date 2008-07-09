Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:42486 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818AbYGIPoD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 11:44:03 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KGbpl-0004Ct-Vs
	for linux-wireless@vger.kernel.org; Wed, 09 Jul 2008 15:43:57 +0000
Received: from 206-248-135-194.dsl.teksavvy.com ([206.248.135.194])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 15:43:57 +0000
Received: from monnier by 206-248-135-194.dsl.teksavvy.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 15:43:57 +0000
To: linux-wireless@vger.kernel.org
From: Stefan Monnier <monnier@iro.umontreal.ca>
Subject: Re: Slow b43 with 2.6.25.9 on an asus wl-700ge home-router
Date: Wed, 09 Jul 2008 11:43:49 -0400
Message-ID: <jwviqvfqd95.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org> (sfid-20080709_174407_032235_D307D477)
References: <jwvlk0bsjk7.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
	<200807091542.13732.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Any idea what might be going on?
> Yeah well.  It's a bug somewhere.

The scary part is that there's only Free Software involved, AFAICT.
That *should* be bug-free, shouldn't it?

> I didn't have time to track it down, yet.

Does that mean that you know about the problem and can reproduce it?

> I have no idea where it is and what kind of bug it is. Pretty time
> consuming job. So if you can do a patch that fixes it, I will take it. ;)

Having too much time on my hand, and being naturally brilliant, I just
came up with the obvious fix, see attached patch.

More seriously: I am not familiar with any part of the kernel code, so
it's very unlikely that I'll find the time and motivation to delve into
it and come up with a patch.  But if you could use some other kind of
help (e.g. some things to test, some printks to add to the code to
collect various kinds of data, ...), please holler,


        Stefan

