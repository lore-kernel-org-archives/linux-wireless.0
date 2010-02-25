Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933348Ab0BYUx5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 15:53:57 -0500
Date: Thu, 25 Feb 2010 15:53:42 -0500
From: Josef Bacik <josef@redhat.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: prahal@yahoo.com, Pavel Roskin <proski@gnu.org>,
	John Linville <linville@tuxdriver.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/2] rt2x00 : hw support txdone implementation.
	(without fallback change)
Message-ID: <20100225205342.GF10960@localhost.localdomain>
References: <4B85FA66.2020503@yahoo.com> <1267120092.25296.31.camel@mj> <4B86D0BD.3000803@yahoo.com> <201002252146.22846.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201002252146.22846.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 25, 2010 at 09:46:22PM +0100, Ivo van Doorn wrote:
> Hi,
> 
> Overall this patch has great similarities to something which Josef (CC added)
> has posted earlier. The patch in question was not merged due to some issues,
> but he is working on an updated. You might want to synchronize your work
> with him. :)
> 

I was just looking at this patch series, but I couldn't get it to apply at all.
Alban, does your patch series depend on other patches not in wireless-testing?
It may have just been the whitespaces or something, cause the context looked
right, it just wouldn't apply anything.  Anyway I'm happy to work together, or
I can just send you what I have and I'll be the guinea pig, since this really
isn't my area of expertise.  Thanks,

Josef
