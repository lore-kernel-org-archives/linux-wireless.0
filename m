Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51938 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZHZQOH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 12:14:07 -0400
Subject: [PATCH] rfkill: relicense header file
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	=?ISO-8859-1?Q?I=F1aky_P=E9rez-Gonz=E1lez?=
	<inaky.perez-gonzalez@intel.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Jaswinder Singh Rajput <jaswinder@kernel.org>,
	Michael Buesch <mb@bu3sch.de>,
	Tomas Winkler <tomas.winkler@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Aug 2009 18:13:17 +0200
Message-Id: <1251303197.15619.29.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This header file is copied into userspace tools that
need not be GPLv2 licensed, make that easier.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Iñaky Pérez-González <inaky.perez-gonzalez@intel.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Tomas Winkler <tomas.winkler@intel.com>
---
Need ACK from everybody listed who ever touched this
file according to git. Please?

 include/linux/rfkill.h |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

--- wireless-testing.orig/include/linux/rfkill.h	2009-08-26 18:09:57.000000000 +0200
+++ wireless-testing/include/linux/rfkill.h	2009-08-26 18:10:52.000000000 +0200
@@ -6,20 +6,17 @@
  * Copyright (C) 2007 Dmitry Torokhov
  * Copyright 2009 Johannes Berg <johannes@sipsolutions.net>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
 #include <linux/types.h>


