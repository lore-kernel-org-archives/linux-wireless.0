Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51659 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab3BFPoI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 10:44:08 -0500
Message-ID: <1360165468.7910.18.camel@jlt4.sipsolutions.net> (sfid-20130206_164413_282299_4055BEDC)
Subject: Re: [PATCH 5/5] mwl8k: bump firmware API to 3
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: Jonas Gorski <jogo@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Date: Wed, 06 Feb 2013 16:44:28 +0100
In-Reply-To: <20130206151313.GB373@markyou.marvell.com> (sfid-20130206_162253_315994_D6B8E6C2)
References: <20130103075440.GA20523@markyou.marvell.com>
	 <CAOiHx=kpV8TScc4gQRZUBwUDAEL-j+uoNg3eodKi8WwmAHYg=w@mail.gmail.com>
	 <20130206151313.GB373@markyou.marvell.com>
	 (sfid-20130206_162253_315994_D6B8E6C2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-06 at 20:43 +0530, Yogesh Ashok Powar wrote:
> On Wed, Feb 06, 2013 at 06:31:12AM -0800, Jonas Gorski wrote:
> > On 3 January 2013 08:54, Yogesh Ashok Powar <yogeshp@marvell.com> wrote:
> > > New firmware is required to support
> > > a) Add support for additional ampdu streams
> > > b) Handle corresponding watchdog events to destroy ampdu streams
> > >
> > > Bumping firmware API version by one.
> > 
> > Soo ... where does one get this new firmware version? I don't see it
> > anywhere (especially not in linux-firmware.git). AFAICT mwl8k in
> > ap-mode is currently broken since this patch got in.
> 
> Hi Jonas,
> 
> We have already mailed the API-3 firmware to Ben Hutching for adding
> it to linux-firmware.git.
> 
> Meanwhile please get the new AP firmware from
> https://github.com/yogeshpowar/mwl8k_ap_firmware

I think you really ought to support previous firmware and next firmware
for a while at least so not everybody is forced to upgrade
immediately...

johannes

