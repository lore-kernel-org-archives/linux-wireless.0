Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:6929 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab0GJAwk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jul 2010 20:52:40 -0400
Subject: Re: Compat-wireless release for 2010-07-09 is baked
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTingMmay_a0ZpwxRi2AQ6tVMJLiBSz_bm9HZVFUn@mail.gmail.com>
References: <20100709190222.115F242E2D@repository3.orbit-lab.org>
	 <1278712573.9411.4.camel@mj>
	 <AANLkTingMmay_a0ZpwxRi2AQ6tVMJLiBSz_bm9HZVFUn@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 09 Jul 2010 20:52:35 -0400
Message-Id: <1278723155.10671.7.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-07-09 at 15:29 -0700, Luis R. Rodriguez wrote:

> >> ssh: Could not resolve hostname wireless.kernel.org: Name or service not known
...
> > Perhaps only successful reports should go to the list, and unsuccessful
> > reports should go to those who can fix the problem?
> 
> Sure, I'll try to address this, but also feel free to send patches against:
> 
> http://git.kernel.org/?p=linux/kernel/git/mcgrof/compat-user.git;a=summary

Thanks for the tip!

I don't think I can fix DNS resolution of wireless.kernel.org from the
scripts.

cron-compat could be rewritten to call "mail" explicitly, so that
different addresses are used for different outcomes.  crontab will need
to be changed accordingly.

-- 
Regards,
Pavel Roskin
