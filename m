Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:6578 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbZHZQkr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 12:40:47 -0400
Received: by ey-out-2122.google.com with SMTP id 25so75344eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 09:40:48 -0700 (PDT)
Message-ID: <4A956594.7010205@tuffmail.co.uk>
Date: Wed, 26 Aug 2009 17:40:52 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	=?UTF-8?B?ScOxYWt5IFDDqXJl?= =?UTF-8?B?ei1Hb256w6FsZXo=?=
	<inaky.perez-gonzalez@intel.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Jaswinder Singh Rajput <jaswinder@kernel.org>,
	Michael Buesch <mb@bu3sch.de>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH] rfkill: relicense header file
References: <1251303197.15619.29.camel@johannes.local>
In-Reply-To: <1251303197.15619.29.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> This header file is copied into userspace tools that
> need not be GPLv2 licensed, make that easier.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Iñaky Pérez-González <inaky.perez-gonzalez@intel.com>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: Michael Buesch <mb@bu3sch.de>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> ---
> Need ACK from everybody listed who ever touched this
> file according to git. Please?
>
>  include/linux/rfkill.h |   25 +++++++++++--------------
>  1 file changed, 11 insertions(+), 14 deletions(-)
>
> --- wireless-testing.orig/include/linux/rfkill.h	2009-08-26 18:09:57.000000000 +0200
> +++ wireless-testing/include/linux/rfkill.h	2009-08-26 18:10:52.000000000 +0200
> @@ -6,20 +6,17 @@
>   * Copyright (C) 2007 Dmitry Torokhov
>   * Copyright 2009 Johannes Berg <johannes@sipsolutions.net>
>   *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the
> - * Free Software Foundation, Inc.,
> - * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>   */
>  
>  #include <linux/types.h>
>   

ACK
