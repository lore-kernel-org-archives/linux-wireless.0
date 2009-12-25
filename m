Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36360 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180AbZLYQpa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Dec 2009 11:45:30 -0500
Date: Fri, 25 Dec 2009 11:38:01 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2009-12-24
Message-ID: <20091225163801.GA4481@tuxdriver.com>
References: <20091224204722.GA678@tuxdriver.com> <20091224.135314.193725771.davem@davemloft.net> <20091225044759.GA11186@tuxdriver.com> <20091225005142.ixwgpr0dcg4cc48w-cebfxv@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091225005142.ixwgpr0dcg4cc48w-cebfxv@webmail.spamcop.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 25, 2009 at 12:51:42AM -0500, Pavel Roskin wrote:
> Quoting "John W. Linville" <linville@tuxdriver.com>:
>
>> Hmm...well, I'm at a loss.  It certainly works here. :-)
>
> You may want to see this discussion in LKML:
> http://thread.gmane.org/gmane.linux.kernel/928654/
>
> The error messages look differently though.  Anyway, genregdb.awk  
> appears to require gawk.

Perhaps, but not intentionally.  Hopefully the patch I posted is
sufficient to get things working for non-gawk users...?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
