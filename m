Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:15206 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab0EGBOi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 21:14:38 -0400
Message-ID: <20100506211435.1nfaq83vkg4ccc0g-cebfxv@webmail.spamcop.net>
Date: Thu, 06 May 2010 21:14:35 -0400
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rt61pci: WEP broken in current wireless-testing
References: <20100506075157.whuptq9jgzkww4gs-cebfxv@webmail.spamcop.net>
	<20100506134335.GA4167@tuxdriver.com>
In-Reply-To: <20100506134335.GA4167@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "John W. Linville" <linville@tuxdriver.com>:

> When you get to this, you probably should use wireless-next-2.6
> (or wireless-2.6) for the bisection.  The pulls from linux-2.6 in
> wireless-testing make bisection much more painful than necessary
> (as long as the problem is actually evident in the other kernels).

I know it's painful!

> You can use the 'master-<date>' tags as guidelines for matching
> wireless-testing versions to representative wireless-next-2.6 (or
> wireless-2.6) tree versions.

Thank you for the tips!

-- 
Regards,
Pavel Roskin
