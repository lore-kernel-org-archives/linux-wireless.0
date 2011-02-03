Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077Ab1BCSyL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Feb 2011 13:54:11 -0500
Subject: Re: [PATCH 0/3] libertas_spi fixes
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Vasily Khoruzhick <anarsoul@gmail.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>,
	Colin McCabe <colin@cozybit.com>,
	Marek Vasut <marek.vasut@gmail.com>
Date: Thu, 03 Feb 2011 12:54:52 -0600
In-Reply-To: <20110131195227.GB3065@tuxdriver.com>
References: <1295642690-16646-1-git-send-email-anarsoul@gmail.com>
	 <20110131195227.GB3065@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1296759294.9471.0.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-31 at 14:52 -0500, John W. Linville wrote:
> On Fri, Jan 21, 2011 at 10:44:47PM +0200, Vasily Khoruzhick wrote:
> > This series attempts to fix libertas_spi bug (it calls functions that
> > may sleep from atomic context) and add pm support to libertas_spi.
> > Tested on Zipit Z2 device.
> 
> Are the libertas folks OK with this series?

1 & 2 yes, I'll ack them if you like.  But I think we were waiting on a
response from Vasily about #3, specifically Marek's question about "can
this be done from the resume handler instead of a workqueue".

Dan


