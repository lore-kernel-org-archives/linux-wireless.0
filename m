Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f202.google.com ([209.85.211.202]:34250 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491AbZKDSoe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 13:44:34 -0500
MIME-Version: 1.0
In-Reply-To: <20091104173258.28463.94619.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173258.28463.94619.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 19:44:39 +0100
Message-ID: <14add3d10911041044m53d97880j3c57648b4652c5fb@mail.gmail.com>
Subject: Re: [PATCH 08/41] rt2800usb: use rt2x00usb_register_multiwrite() to
	set key entries
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
> Subject: [PATCH] rt2800usb: use rt2x00usb_register_multiwrite() to set key entries
>
> Since struct hw_key_entry is 32-bytes large and is smaller than
> CSR cache size (which is 64-bytes large) we can use the standard
> rt2x00usb_register_multiwrite() helper to set key entries.
>
> This cleanup is a part of preparations for later code unification.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
