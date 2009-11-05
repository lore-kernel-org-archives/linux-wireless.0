Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:49984 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbZKES5D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2009 13:57:03 -0500
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 23/41] rt2x00: add driver private field to struct rt2x00_dev
Date: Thu, 5 Nov 2009 19:57:05 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173446.28463.62662.sendpatchset@localhost.localdomain> <200911051952.51189.IvDoorn@gmail.com>
In-Reply-To: <200911051952.51189.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911051957.06276.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 05 November 2009, Ivo van Doorn wrote:
> On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] rt2x00: add driver private field to struct rt2x00_dev
> > 
> > Enhance rt2x00 infrastructure by adding driver specific field to
> > struct rt2x00_dev.
> > 
> > The new field will be used by rt2800 drivers for chipset registers
> > access abstraction layer.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

Sorry I have a better idea, please the pointer into struct rt2x00_ops,
that way you can assign it statically like the rest of that structure.
That makes actually sense since all other function ops structures
are assigned like that as well.

Ivo
