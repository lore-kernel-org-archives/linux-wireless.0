Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49557 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329Ab0DPNpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 09:45:12 -0400
Date: Fri, 16 Apr 2010 09:43:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	gwingerde@gmail.com
Subject: Re: [PATCH] wireless: rt2x00: rt2800usb: delete Allwin devices
Message-ID: <20100416134326.GD8554@tuxdriver.com>
References: <1271413005-2509-1-git-send-email-xose.vazquez@gmail.com> <u2ja32f33a41004160417jfcf1db3bw62d464405fead085@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <u2ja32f33a41004160417jfcf1db3bw62d464405fead085@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 16, 2010 at 01:17:07PM +0200, Ivo Van Doorn wrote:
> On Fri, Apr 16, 2010 at 12:16 PM, Xose Vazquez Perez
> <xose.vazquez@gmail.com> wrote:
> > Common sense says:
> > (0x8516, 0x2070) is RT2070
> > (0x8516, 0x2770) is RT2770
> > (0x8516, 0x2870) is RT2870
> > [...]
> >
> > but Allwin doesn't sell USB dongles nor PCI boards, only voip-routers
> > http://www.allwin.com.tw/eng/modules/tinyd0/content/index.php?id=1
> 
> But how about the case where the company name is wrong and the ID's are valid?
> That means we only should update the comment, rather then deleting the ID's.

Or the case where someone ports Linux to those voip routers...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
