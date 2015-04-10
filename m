Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151AbbDJHbY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2015 03:31:24 -0400
Message-ID: <55277C47.4080201@nod.at> (sfid-20150410_093129_238364_BD39CF42)
Date: Fri, 10 Apr 2015 09:31:19 +0200
From: Richard Weinberger <richard@nod.at>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Steven Rostedt <rostedt@goodmis.org>
CC: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, sameo@linux.intel.com,
	aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	davem@davemloft.net, kadlec@blackhole.kfki.hu, kaber@trash.net,
	pablo@netfilter.org
Subject: Re: [PATCH 5/5 v2] netfilter: Fix format string of nfnetlink_log
 proc file
References: <1428616637-21690-1-git-send-email-richard@nod.at>	 <1428616637-21690-5-git-send-email-richard@nod.at> <1428619177.5413.15.camel@perches.com>
In-Reply-To: <1428619177.5413.15.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 10.04.2015 um 00:39 schrieb Joe Perches:
> On Thu, 2015-04-09 at 23:57 +0200, Richard Weinberger wrote:
>> The printed values are all of type unsigned integer, therefore use
>> %u instead of %d. Otherwise an user can face negative values.
> 
> Hey Richard.
> 
> Just to clarify, this patch is for net and not for net-next
> as net-next has removed the seq_printf return uses.
> 
> Are you going to submit an equivalent patch for net-next?

Hmm, you are right. It took me a few minutes to figure out what happened
because I did rebase my patches to net-next and fixed up 5/5 already.
Reading yesterday's bash history shows that I've used
git format-patch in a wrong way such that the comments from the old
branch were taken.

Thanks,
//richard
