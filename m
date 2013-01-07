Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:44489 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab3AGX4M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 18:56:12 -0500
Received: by mail-la0-f41.google.com with SMTP id em20so17609790lab.28
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2013 15:56:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1357601640.12182.6.camel@canaries64>
References: <1357601640.12182.6.camel@canaries64>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 8 Jan 2013 10:55:50 +1100
Message-ID: <CAGRGNgV0HVzSn5jr3rSaEg7VnS0Qp1aXbwyAM-mkdyBnaO1oGA@mail.gmail.com> (sfid-20130108_005620_102386_5BA9EF25)
Subject: Re: [PATCH 1/3] staging: vt6656: change bssdb/rxtx/wpa2 to new
 structures v2
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Malcolm,

One quick point of note, when releasing newer versions of your
patches, it's preferred that you change the subject to something like

[PATCH v2 1/3] staging: vt6656: change bssdb/rxtx/wpa2 to new structures

instead of

[PATCH 1/3] staging: vt6656: change bssdb/rxtx/wpa2 to new structures v2

Everything outside the square brackets will go into the kernel log and
things like "version 2" or "rebased version" have no real meaning
outside the original discussion of the patch.

On Tue, Jan 8, 2013 at 10:34 AM, Malcolm Priestley <tvboxspy@gmail.com> wrote:
> rebased version

Also, notes about the patch, e.g. "rebased version" are generally put
after the description ...

> This patch cleans up function declarations, definitions and local variables
> where appropriate replacing types defined in "type.h" with linux/types.h.
>
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---

... here.

>  drivers/staging/vt6656/bssdb.c | 293 ++++++++--------
>  drivers/staging/vt6656/bssdb.h | 130 ++++---
>  drivers/staging/vt6656/rxtx.c  | 757 +++++++++++++----------------------------
>  drivers/staging/vt6656/rxtx.h  |  31 +-
>  drivers/staging/vt6656/wpa2.c  |  19 +-
>  5 files changed, 452 insertions(+), 778 deletions(-)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
