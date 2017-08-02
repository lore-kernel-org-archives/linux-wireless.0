Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:35848 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751991AbdHBQYw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 12:24:52 -0400
Received: by mail-pg0-f53.google.com with SMTP id v77so17443082pgb.3
        for <linux-wireless@vger.kernel.org>; Wed, 02 Aug 2017 09:24:52 -0700 (PDT)
Date: Wed, 2 Aug 2017 09:24:48 -0700
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [EXT] Re: pull-request mwifiex-firmware 2017-08-01
Message-ID: <20170802162445.GA56427@google.com> (sfid-20170802_182455_979842_CA84A468)
References: <202374ffb3a9487cbbd7f514972ed325@SC-EXCH02.marvell.com>
 <20170801195100.GA98003@google.com>
 <d39c8e0aeb6048078c94e39c188f4c16@SC-EXCH02.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d39c8e0aeb6048078c94e39c188f4c16@SC-EXCH02.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ganapathi,

On Wed, Aug 02, 2017 at 09:44:51AM +0000, Ganapathi Bhat wrote:
> Hi Brian,
> 
> > On Tue, Aug 01, 2017 at 06:35:40PM +0000, Ganapathi Bhat wrote:
> > > The following changes since commit
> > 11db1311bff6fed84d11b03fbfb142209c1239ab:

^^^ Note that even the above commit is not in linux-firmware.git. Your
pull requests haven't been making it through.

> > >   linux-firmware: update Marvell PCIe-USB8897-A2 firmware image
> > (2017-06-05 02:19:40 -0700)
> > >
> > > are available in the git repository at:
> > >
> > >   git://git.marvell.com/mwifiex-firmware.git
> > 
> > Is your server down? I can't get a response.
> No, it is running fine. I did a clone just now to confirm the same.

Still not working today:

   $ git pull
   fatal: unable to connect to git.marvell.com:
   git.marvell.com[0: 199.233.58.162]: errno=Connection timed out

   $ git remote -v
   origin	git://git.marvell.com/mwifiex-firmware.git (fetch)
   origin	git://git.marvell.com/mwifiex-firmware.git (push)

It also looks like this is not the first time:

Re: pull-request mwifiex-firmware 2017-06-05
http://marc.info/?l=linux-wireless&m=149754207831326&w=2

Your team's last pull request was never picked up because your server isn't
working. Maybe you only have a company-internal instance working now?

Brian
