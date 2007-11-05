Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:60503 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753831AbXKEVFw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2007 16:05:52 -0500
Message-ID: <472F85A6.90603@lwfinger.net> (sfid-20071105_210601_360559_6D80E802)
Date: Mon, 05 Nov 2007 15:05:42 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Problem with wireless-2.6
References: <472F57A6.3020107@lwfinger.net> <20071105182825.GA3478@tuxdriver.com>
In-Reply-To: <20071105182825.GA3478@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> 
> Well, I'm not sure.  What is the purpose of your 'git pull'? 

To get the latest everything branch.

> What is the head commit on your everything branch?  At present, it should be:
> 
> 	commit 792296c80171081ab1eeb59a206aed651a27fcb0
> 	Merge: 0119130... 286c21f...
> 	Author: John W. Linville <linville@tuxdriver.com>
> 	Date:   Fri Nov 2 17:14:55 2007 -0400
> 
> 	    Merge branch 'ath5k' into everything
> 
> FWIW, 'git describe' on my everything branch also returns
> v2.6.24-rc1-155-g792296c.  What makes you think this is wrong?

That was after I repulled the entire tree. Before it was at 2.6.23-rc9.

>From other comments, I think I needed a git rebase command.

Larry
