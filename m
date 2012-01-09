Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from h118.nextmail.ru ([194.67.36.118]:39353 "EHLO h118.nextmail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab2AILLw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 06:11:52 -0500
To: =?koi8-r?B?TW9oYW1tZWQgU2hhZmk=?= <shafi.wireless@gmail.com>
From: =?koi8-r?B?TVI=?= <g7af0ec1e3ea1e7b1@nextmail.ru>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	"=?koi8-r?B?UmFqa3VtYXIgTWFub2hhcmFu?=" <rmanohar@qca.qualcomm.com>
Subject: =?koi8-r?B?UmU6IGF0aDlrIGNyYXNoIDMuMi1yYzc=?=
Date: Mon, 09 Jan 2012 15:11:49 +0400
Message-ID: <NEXT-4f0acb7559f2f7.91746772@nextmail.ru> (sfid-20120109_121239_727233_61FAC151)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> So, I am building 3.2 with two patches: over/under-flow catcher (pity
>that
>> it seems to be on a multiple-times-per-second codepath and just leaving
>the
> > checks there for everyone is suboptimal) and allegedely proper fix. Both
> > applied OK with a small offset.
> 
> as per our assumption, we should not see those over/underflow errors,
> with the patch
> above mentioned. please let us know if you hit upon this warnings,
> even after the proper fix.

2 hours in. It looks like 10%-20% throughput loss (both up and down with 
similar ratio) relative to "remove suspicious code" build. It may be some 
other change, of course (slightly moving the notebook, removing USB device 
charging from the notebook or something like that)


