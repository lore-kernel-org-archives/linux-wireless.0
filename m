Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56110 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbbE1JDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 05:03:21 -0400
Message-ID: <1432803793.2459.2.camel@sipsolutions.net> (sfid-20150528_110326_727746_87D71ECF)
Subject: Re: kmalloc panic
From: Johannes Berg <johannes@sipsolutions.net>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: pavani <pavani.muthyala@redpinesignals.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org,
	Linux Kernel Network Developers <netdev@vger.kernel.org>
Date: Thu, 28 May 2015 11:03:13 +0200
In-Reply-To: <CAM_iQpUGLW44vzkN-5TJ9ww3RSz=2sRMnm7GKP6V0N9WGszRZQ@mail.gmail.com> (sfid-20150528_071604_270429_6EC02675)
References: <5565CAA1.9070409@redpinesignals.com>
	 <CAM_iQpUGLW44vzkN-5TJ9ww3RSz=2sRMnm7GKP6V0N9WGszRZQ@mail.gmail.com>
	 (sfid-20150528_071604_270429_6EC02675)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-05-27 at 22:15 -0700, Cong Wang wrote:

> > rsi_client: module license 'Proprietary' taints kernel.
> > Disabling lock debugging due to kernel taint
> > RSI_Init called and registering the client driver

If this is what I think it is - the redpine signals wifi driver, then I
have no interest in this bug report whatsoever.

Please tell us
 * the exact kernel version, best with local patches
 * the wifi driver used

> > INFO: Allocated in 0x10100100 age=2669517238 cpu=16842820 pid=335563024

and what function this really was (0x10100100 isn't really useful).

johannes

