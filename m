Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36682 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753342AbZHZXK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 19:10:26 -0400
Date: Wed, 26 Aug 2009 20:10:23 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	=?iso-8859-1?Q?I=F1aky_P=E9rez-Gonz=E1lez?=
	<inaky.perez-gonzalez@intel.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Jaswinder Singh Rajput <jaswinder@kernel.org>,
	Michael Buesch <mb@bu3sch.de>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH] rfkill: relicense header file
Message-ID: <20090826231023.GD23973@khazad-dum.debian.net>
References: <1251303197.15619.29.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1251303197.15619.29.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 26 Aug 2009, Johannes Berg wrote:
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

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

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
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
