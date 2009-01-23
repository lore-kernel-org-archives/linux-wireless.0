Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42260
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752483AbZAWHjU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 02:39:20 -0500
Date: Thu, 22 Jan 2009 23:39:22 -0800 (PST)
Message-Id: <20090122.233922.53714287.davem@davemloft.net> (sfid-20090123_083925_682244_215F265D)
To: jeffrey.t.kirsher@intel.com
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: net-next-2.6 is live
From: David Miller <davem@davemloft.net>
In-Reply-To: <9929d2390901221917s606489c3wfe77612c9c989433@mail.gmail.com>
References: <20090121.165820.171747430.davem@davemloft.net>
	<9929d2390901221917s606489c3wfe77612c9c989433@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu, 22 Jan 2009 19:17:26 -0800

> On Wed, Jan 21, 2009 at 4:58 PM, David Miller <davem@davemloft.net> wrote:
> >
> > Ok, I've pushed all of the patches I've applied for 2.6.30 off to:
> >
> >        master.kernel.org:/pub/scm/linux/kernel/git/davem/net-next-2.6.git
> >
> > Enjoy.
> > --
> 
> Dave, the net-next tree seems to be missing this patch...
 ...
> e1000e: drop lltx, remove unnecessary lock

Another lost change, sorry, I added it and let's hope it sticks
this so time.
