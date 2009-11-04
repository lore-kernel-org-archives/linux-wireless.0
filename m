Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:65044 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757736AbZKDS0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 13:26:11 -0500
MIME-Version: 1.0
In-Reply-To: <20091104173210.28463.95558.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173210.28463.95558.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 19:26:16 +0100
Message-ID: <14add3d10911041026r54a0abd1h953609dd7cb7224a@mail.gmail.com>
Subject: Re: [PATCH 02/41] rt2800pci: make Kconfig help entry more helpful
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 4, 2009 at 6:32 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800pci: make Kconfig help entry more helpful
>
> Document known issues with the driver to aid distribution makers,
> users and developers in making informed decisions instead of wasting
> their time needlessly.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> This reflects the actual state of affairs for driver in net-next tree.
>

Maybe we should consider making this one depend on BROKEN, for the
moment at least?

However, for what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
