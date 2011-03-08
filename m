Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33127 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab1CHRSD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 12:18:03 -0500
Subject: Re: 2.6.38-rc7, iwlagn warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Mathias =?ISO-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>
Cc: wwguy <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <AANLkTimBfOM8yxdh_Z4Bw_ww4WRtQXzdoEx6ZL_TT5YU@mail.gmail.com>
References: <AANLkTin0PGOfHr3AvQk-BAhyMY7ihYMU1-wX4RJG=1YT@mail.gmail.com>
	 <20110304134648.GB9866@tuxdriver.com>
	 <1299251879.24333.3.camel@wwguy-ubuntu>
	 <AANLkTinfCc0e4BtBxoq7MHtgv54HJk-yU=gQj9Xm_=R9@mail.gmail.com>
	 <AANLkTi=+jfk5+tWewwnx+SHj+FQAXd03sPC3mDW32GUK@mail.gmail.com>
	 <AANLkTikUE-LLSBNH=cNmPZ+Wenff5RxKcfK0kJXp9Wk+@mail.gmail.com>
	 <1299334144.3826.8.camel@jlt3.sipsolutions.net>
	 <AANLkTikQHUq95e9=3tG5WrayaxUu+K1FdAftJ3y72BTn@mail.gmail.com>
	 <1299597447.4676.25.camel@jlt3.sipsolutions.net>
	 <AANLkTinj1f0Kx5X6eqYEdyzT_3XLbtbLtwbp7jPN2LSH@mail.gmail.com>
	 <1299602750.3734.2.camel@jlt3.sipsolutions.net>
	 <AANLkTimBfOM8yxdh_Z4Bw_ww4WRtQXzdoEx6ZL_TT5YU@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 18:18:00 +0100
Message-ID: <1299604680.3734.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-08 at 17:13 +0000, Mathias Burén wrote:

> 1299604089.756872: WPS: UUID based on MAC address - hexdump(len=16):
> cc fa a1 31 39 a7 5c 33 96 d8 eb 09 dd fe 7f 0f
> 1299604089.768927: ssid - hexdump_ascii(len=11):
>      55 62 75 6e 74 75 41 64 68 6f 63                  UbuntuAdhoc
> 1299604094.005785: ssid - hexdump_ascii(len=11):
>      55 62 75 6e 74 75 41 64 68 6f 63                  UbuntuAdhoc
> 
> Anything else I can try/provide?

Could you do the -dddt thing as explained on the link I had before?

Obviously, we're now looking for the cause -- while the warning still
shouldn't happen *even if userspace is misbehaving*. The trace will
hopefully help me figure out why we get the warning, I'll look at it
later.

johannes

