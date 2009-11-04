Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f202.google.com ([209.85.211.202]:65142 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbZKDSgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 13:36:24 -0500
MIME-Version: 1.0
In-Reply-To: <20091104173239.28463.22571.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173239.28463.22571.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 19:36:29 +0100
Message-ID: <14add3d10911041036s3f392f0ep1d6ba29a96209847@mail.gmail.com>
Subject: Re: [PATCH 06/41] rt2800pci: fix comment about IV/EIV fields
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
> Subject: [PATCH] rt2800pci: fix comment about IV/EIV fields
>
> The bit tested by hardware is TXD_W3_WIV and its value
> equals the negated value of ENTRY_TXD_ENCRYPT_IV bit.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
