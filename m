Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3381 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbYBEPcL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 10:32:11 -0500
Date: Tue, 5 Feb 2008 10:11:19 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Ian Brown <ianbrn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Git cloning the latest, bleeding edge wireless drivers tree
Message-ID: <20080205151119.GA4252@tuxdriver.com> (sfid-20080205_153215_950688_7C5B00DA)
References: <d0383f90802050547h71a588edl3cf083a356cbdeed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d0383f90802050547h71a588edl3cf083a356cbdeed@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 05, 2008 at 03:47:02PM +0200, Ian Brown wrote:
> Hello,
> 
> Which is the path by which I should git-clone the latest, bleeding edge
> wireless drivers tree ? (development)
> I assume it is somewhere under
> http://www.kernel.org/pub/linux/kernel/people/linville/
> ; but where exactly?

More like:

	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git

Don't forget to checkout the 'everything' branch.

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com
