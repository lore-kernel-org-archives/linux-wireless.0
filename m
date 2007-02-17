Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3859 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965424AbXBRAID (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Feb 2007 19:08:03 -0500
Date: Sat, 17 Feb 2007 18:36:50 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Please pull 'upstream' branch of wireless-2.6 (2007-02-14)
Message-ID: <20070217233650.GA4310@tuxdriver.com>
References: <20070214212817.GB28318@tuxdriver.com> <45D7647B.8090704@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <45D7647B.8090704@garzik.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 17, 2007 at 03:24:27PM -0500, Jeff Garzik wrote:
> John W. Linville wrote:
> >Some late-breaking small and/or important changes before the 2.6.21
> >merge window closes...

> ACK.  Tried to pull, but there were conflicts with netdev#upstream. 
> Since there are dependencies in netdev#upstream, looks like you need to 
> resend against that.
 
Ah, yes...I cloned your 'upstream' branch, pulled from my
'upstream' branch, resolved the conflicts, and committed on my new
'upstream-jgarzik' branch.

Please pull from here:

	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream-jgarzik

Thanks!

John
-- 
John W. Linville
linville@tuxdriver.com
