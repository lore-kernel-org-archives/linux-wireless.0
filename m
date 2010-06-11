Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33841 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689Ab0FKSTa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jun 2010 14:19:30 -0400
Subject: Re: [PATCH] wireless: orphan ipw2x00 drivers
From: reinette chatre <reinette.chatre@intel.com>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1276279556.1637.79.camel@Joe-Laptop.home>
References: <1276134269-2273-1-git-send-email-yi.zhu@intel.com>
	 <20100610014547.GA2318@tuxdriver.com>
	 <20100609.225243.179940910.davem@davemloft.net>
	 <1276278467.25793.1296.camel@rchatre-DESK>
	 <1276279556.1637.79.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Jun 2010 11:19:29 -0700
Message-ID: <1276280369.25793.1354.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-06-11 at 11:05 -0700, Joe Perches wrote:
> On Fri, 2010-06-11 at 10:47 -0700, reinette chatre wrote:
> > This is why we changed the status to "Orphaned" since it really seem to
> > reflect our status at this time. We really do not know what else to do. 
> > 
> > I understand that there is a concern with low level bugs for which
> > hardware documentation may be needed. We surely will do our best to help
> > out when these situations arise. 
> 
> The S: line is just a guide.
> 
> Maybe change it to something more descriptive like:
> 
> S:	Orphaned, might dig up moldy faxed copies of hardware docs
> 

That would be ideal if we can have some custom text in this file. We
actually looked into this but found that the different status field
values are currently used strictly by all entries in MAINTAINERS. Not
knowing what parses these files we stuck with the current style.

Reinette



