Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:55094 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756701Ab3BFPWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 10:22:48 -0500
Date: Wed, 6 Feb 2013 20:43:13 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: Jonas Gorski <jogo@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH 5/5] mwl8k: bump firmware API to 3
Message-ID: <20130206151313.GB373@markyou.marvell.com> (sfid-20130206_162253_315994_D6B8E6C2)
References: <20130103075440.GA20523@markyou.marvell.com>
 <CAOiHx=kpV8TScc4gQRZUBwUDAEL-j+uoNg3eodKi8WwmAHYg=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOiHx=kpV8TScc4gQRZUBwUDAEL-j+uoNg3eodKi8WwmAHYg=w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 06, 2013 at 06:31:12AM -0800, Jonas Gorski wrote:
> On 3 January 2013 08:54, Yogesh Ashok Powar <yogeshp@marvell.com> wrote:
> > New firmware is required to support
> > a) Add support for additional ampdu streams
> > b) Handle corresponding watchdog events to destroy ampdu streams
> >
> > Bumping firmware API version by one.
> 
> Soo ... where does one get this new firmware version? I don't see it
> anywhere (especially not in linux-firmware.git). AFAICT mwl8k in
> ap-mode is currently broken since this patch got in.

Hi Jonas,

We have already mailed the API-3 firmware to Ben Hutching for adding
it to linux-firmware.git.

Meanwhile please get the new AP firmware from
https://github.com/yogeshpowar/mwl8k_ap_firmware


Thanks
Yogesh
