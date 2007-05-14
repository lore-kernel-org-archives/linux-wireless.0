Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3239 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756821AbXENScs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2007 14:32:48 -0400
Date: Mon, 14 May 2007 14:23:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Matteo Croce <rootkit85@yahoo.it>
Cc: Dan Williams <dcbw@redhat.com>,
	Michal Schmidt <mschmidt@redhat.com>,
	linux-wireless@vger.kernel.org
Subject: Re: airo works badly
Message-ID: <20070514182336.GC6999@tuxdriver.com>
References: <200705060231.28480.rootkit85@yahoo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200705060231.28480.rootkit85@yahoo.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 06, 2007 at 02:31:28AM +0200, Matteo Croce wrote:
> Now I get another error while ifdown && ifup again:
> 
> airo(eth0): Max tries exceeded when issueing command
> airo(eth0): enable_MAC: Cannot enable MAC, err=65535
> airo(eth0): Max tries exceeded when issueing command

Per our IRC conversation, it seems that this problem emerged for you
between 2.6.16 and 2.6.17.  Please try using git-bisect to determine
exactly which patch caused this issue for you.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
