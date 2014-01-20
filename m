Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59832 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaATKuU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 05:50:20 -0500
Message-ID: <1390215015.4335.6.camel@jlt4.sipsolutions.net> (sfid-20140120_115024_095547_2DCBE8F0)
Subject: Re: [PATCH V2] cfg80211: Do not call CRDA when using internal
 regulatory database
From: Johannes Berg <johannes@sipsolutions.net>
To: Chaitanya T K <chaitanya.mgit@gmail.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com
Date: Mon, 20 Jan 2014 11:50:15 +0100
In-Reply-To: <1390009167-4766-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20140118_153524_887371_952B5952)
References: <1390009167-4766-1-git-send-email-chaitanya.mgit@gmail.com>
	 (sfid-20140118_153524_887371_952B5952)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2014-01-18 at 07:09 +0530, Chaitanya T K wrote:
> When using internal regulatory data base kconfig option,
> do not try to call crda. This completely defeats the 
> purpose of enabling internal regulatory db.

I still think that this is a significant userspace API change, so I'm
not going to apply it. Find another solution.

johannes

