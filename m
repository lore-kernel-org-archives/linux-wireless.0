Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3349 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbXLOS2d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Dec 2007 13:28:33 -0500
Date: Sat, 15 Dec 2007 12:56:56 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP][PATCH] rc80211_pid: Send events to userspace for
	debugging
Message-ID: <20071215175656.GB3096@tuxdriver.com> (sfid-20071215_182838_118221_3BDAB8AA)
References: <1197414686.7030.27.camel@localhost> <20071214231452.21ece93d@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071214231452.21ece93d@morte>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 14, 2007 at 11:14:52PM +0100, Stefano Brivio wrote:
> Here comes an amended patch which works with my tree and should be more
> mergeable (as it splits the debugfs stuff to another file) just for
> convenience and to save Mattias some hassle. Hope this helps.

Speaking of mergeable, we need some "final" patches RSN if we want
to have this available in 2.6.25.  So, are we satisified with it?

John
-- 
John W. Linville
linville@tuxdriver.com
