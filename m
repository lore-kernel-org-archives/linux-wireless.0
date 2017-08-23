Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53354 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932413AbdHWQw7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Aug 2017 12:52:59 -0400
Date: Wed, 23 Aug 2017 09:52:58 -0700
From: Kyle McMartin <kyle@infradead.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Ganapathi Bhat <gbhat@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>, linux-firmware@kernel.org
Subject: Re: [EXT] Re: pull-request mwifiex-firmware 2017-08-01
Message-ID: <20170823165258.GR13400@bombadil.infradead.org> (sfid-20170823_185423_724007_9568C339)
References: <202374ffb3a9487cbbd7f514972ed325@SC-EXCH02.marvell.com>
 <20170801195100.GA98003@google.com>
 <d39c8e0aeb6048078c94e39c188f4c16@SC-EXCH02.marvell.com>
 <20170802162445.GA56427@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170802162445.GA56427@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 02, 2017 at 09:24:48AM -0700, Brian Norris wrote:
> Hi Ganapathi,
> 
> On Wed, Aug 02, 2017 at 09:44:51AM +0000, Ganapathi Bhat wrote:
> > Hi Brian,
> > 
> > > On Tue, Aug 01, 2017 at 06:35:40PM +0000, Ganapathi Bhat wrote:
> > > > The following changes since commit
> > > 11db1311bff6fed84d11b03fbfb142209c1239ab:
> 
> ^^^ Note that even the above commit is not in linux-firmware.git. Your
> pull requests haven't been making it through.
> 
> > > >   linux-firmware: update Marvell PCIe-USB8897-A2 firmware image
> > > (2017-06-05 02:19:40 -0700)
> > > >
> > > > are available in the git repository at:
> > > >
> > > >   git://git.marvell.com/mwifiex-firmware.git
> > > 
> > > Is your server down? I can't get a response.
> > No, it is running fine. I did a clone just now to confirm the same.
> 
> Still not working today:
> 
>    $ git pull
>    fatal: unable to connect to git.marvell.com:
>    git.marvell.com[0: 199.233.58.162]: errno=Connection timed out
> 
>    $ git remote -v
>    origin	git://git.marvell.com/mwifiex-firmware.git (fetch)
>    origin	git://git.marvell.com/mwifiex-firmware.git (push)
> 
> It also looks like this is not the first time:
> 
> Re: pull-request mwifiex-firmware 2017-06-05
> http://marc.info/?l=linux-wireless&m=149754207831326&w=2
> 
> Your team's last pull request was never picked up because your server isn't
> working. Maybe you only have a company-internal instance working now?
> 

I'm also having trouble connecting to it.

regards, Kyle
