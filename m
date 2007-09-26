Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57530
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754088AbXIZCbm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 22:31:42 -0400
Date: Tue, 25 Sep 2007 19:31:42 -0700 (PDT)
Message-Id: <20070925.193142.112833471.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: yi.zhu@intel.com, hch@infradead.org, jeff@garzik.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Please pull 'iwlwifi' branch of wireless-2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070921013403.GA3170@tuxdriver.com>
References: <20070919101326.GA32432@infradead.org>
	<1190337630.5718.136.camel@debian.sh.intel.com>
	<20070921013403.GA3170@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 20 Sep 2007 21:34:03 -0400

> On Fri, Sep 21, 2007 at 09:20:30AM +0800, Zhu Yi wrote:
> > On Wed, 2007-09-19 at 11:13 +0100, Christoph Hellwig wrote:
> > > it really needs to be moved into a directory of it's own.
> > 
> > It used to be... John?
> 
> Fine by me -- I guess I misinterpreted the some other statements to
> make me think we wanted as flat a directory structure as possible.

I've taken care of this during the net-2.6.24 rebase I'm working
on today.
