Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:53533 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754935Ab2K1PWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 10:22:35 -0500
Date: Wed, 28 Nov 2012 10:17:28 -0500 (EST)
From: Anders Kaseorg <andersk@MIT.EDU>
To: Tejun Heo <tj@kernel.org>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"John W. Linville" <linville@tuxdriver.com>
cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Wireless regression in workqueue: use mod_delayed_work() instead
 of __cancel + queue
In-Reply-To: <alpine.DEB.2.00.1211280953350.26602@dr-wily.mit.edu>
Message-ID: <alpine.DEB.2.00.1211281016320.26602@dr-wily.mit.edu> (sfid-20121128_162238_788298_ED47B9DB)
References: <alpine.DEB.2.00.1211280953350.26602@dr-wily.mit.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 28 Nov 2012, Anders Kaseorg wrote:
> My Intel 6250 wireless card (iwldvm) can no longer associate with a 
> WPA-Enterprise network (PEAP-MSCHAPv2).  To my surprise, I bisected this 
> regression to commit e7c2f967445dd2041f0f8e3179cca22bb8bb7f79, 
> workqueue: use mod_delayed_work() instead of __cancel + queue.
> 
> A bunch of logs collected by Ubuntu apport are in this bug report: 
>   https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1083980
> 
> How can I help to debug this?
> 
> I see that someone else reported another regression with the same commit 
> last week, although this looks unrelated at first glance: 
>   http://thread.gmane.org/gmane.linux.kernel/1395938
> 
> Anders

(Oops, re-sending to fix a typo in the LKML address.)

Anders
