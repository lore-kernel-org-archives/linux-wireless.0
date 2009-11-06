Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:34905 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758198AbZKFSRA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 13:17:00 -0500
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 02/41] rt2800pci: make Kconfig help entry more helpful
Date: Fri, 6 Nov 2009 17:13:09 +0100
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173210.28463.95558.sendpatchset@localhost.localdomain> <14add3d10911041026r54a0abd1h953609dd7cb7224a@mail.gmail.com>
In-Reply-To: <14add3d10911041026r54a0abd1h953609dd7cb7224a@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200911061713.09133.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 04 November 2009 19:26:16 Gertjan van Wingerde wrote:
> On Wed, Nov 4, 2009 at 6:32 PM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] rt2800pci: make Kconfig help entry more helpful
> >
> > Document known issues with the driver to aid distribution makers,
> > users and developers in making informed decisions instead of wasting
> > their time needlessly.
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> > This reflects the actual state of affairs for driver in net-next tree.
> >
> 
> Maybe we should consider making this one depend on BROKEN, for the
> moment at least?

Sounds fine with me, would you be willing to take care of this?

Thanks.
-- 
Bartlomiej Zolnierkiewicz
