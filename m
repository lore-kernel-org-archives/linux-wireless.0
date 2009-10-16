Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hogsmeade.leitwerk.net ([217.28.96.50]:33625 "EHLO
	hogsmeade.leitwerk.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759137AbZJPNSQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 09:18:16 -0400
From: Simon Raffeiner <sturmflut@lieberbiber.de>
To: "John W. Linville" <linville@tuxdriver.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [rt2x00-users] [PATCH] rt73usb.c : more ids
Date: Fri, 16 Oct 2009 15:17:36 +0200
References: <4AD468DB.4050700@gmail.com> <880c1630910130520p30c06846k8692634ec277340@mail.gmail.com> <20091013145600.GB2747@tuxdriver.com>
In-Reply-To: <20091013145600.GB2747@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200910161517.36838.sturmflut@lieberbiber.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Xose, Luis and John,

On Tue, Oct 13, 2009 at 01:20:17PM +0100, Luis Correia wrote:
> Are you absolutely sure that these devices are really rt73usb?
>
> By being in the windows inf file doesn't mean they would work in Linux.

I did the same thing Xose did and came up with even more new IDs. The Windows 
driver specifically supports only RT73 chipsets and I did my best to ensure 
that these are truly RT73 devices.

There is no guarantee that the Linux driver will perfectly support those new 
devices, but I think most should just work fine. If they don't the user at 
least knows where to file the bug report.

I may be wrong but at least for me this concept worked - I bought an 
RT2070L based device which is currently not supported by rt2800usb, the 
fact that the driver got loaded pointed me into the right direction 
(http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=5&t=5245&hilit=rt2070).

I'll post the patch (new ids and some cleanups) if everybody's okay with it.

regards,
Simon Raffeiner
