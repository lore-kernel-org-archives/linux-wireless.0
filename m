Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:42980 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759315AbZKFSRE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 13:17:04 -0500
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 13/41] rt2800usb: add rt2800_regbusy_read() wrapper
Date: Fri, 6 Nov 2009 17:23:10 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173334.28463.13649.sendpatchset@localhost.localdomain> <200911051949.28617.IvDoorn@gmail.com>
In-Reply-To: <200911051949.28617.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200911061723.10099.bzolnier@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 05 November 2009 19:49:28 Ivo van Doorn wrote:
> On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] rt2800usb: add rt2800_regbusy_read() wrapper
> > 
> > Part of preparations for later code unification.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> The macros are the same for rt2800pci and rt2800usb.
> So it might be better to move the entire define set into rt2800lib.h

Indeed, it wasn't possible before patches #13-14 but it is now.

Would you like to send an incremental (on top the series) fix for it?

Thanks.
-- 
Bartlomiej Zolnierkiewicz
