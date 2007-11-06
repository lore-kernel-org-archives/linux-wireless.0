Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:34084 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929AbXKFDpv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2007 22:45:51 -0500
Message-ID: <472FE367.9060900@lwfinger.net> (sfid-20071106_034556_980994_BC90FE62)
Date: Mon, 05 Nov 2007 21:45:43 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Problem with wireless-2.6
References: <472F57A6.3020107@lwfinger.net> <1194315035.22337.13.camel@dv>
In-Reply-To: <1194315035.22337.13.camel@dv>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> 
> Just add "--track" to the git-checkout command, and it will be fine:
> 
> [proski@dv junk]$ git checkout --track -b everything origin/everything
> Branch everything set up to track remote branch refs/remotes/origin/everything.
> Switched to a new branch "everything"
> [proski@dv junk]$ git-pull
> Already up-to-date.
> [proski@dv junk]$
> 
> Or better yet, add this to ~/.gitconfig:
> 
> [branch]
>         autosetupmerge = true
> 
> This would be equivalent to using "--track" by default.  Please make
> sure you have a recent version of git, as --track appeared first in
> git-1.5.1.
> 

Pavel,

Thanks. I deleted the everything branch and recreated it with --track, and all is good.

Larry
