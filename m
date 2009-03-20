Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:52326 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbZCTT7q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 15:59:46 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Christian Lamparter <chunkeey@web.de>
Subject: Re: [RFC][PATCH 4/5] ar9170: USB frontend driver
Date: Fri, 20 Mar 2009 20:58:34 +0100
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
References: <200903170410.20261.chunkeey@web.de> <200903202036.43107.chunkeey@web.de>
In-Reply-To: <200903202036.43107.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903202058.34420.mb@bu3sch.de> (sfid-20090320_205950_810612_C1C0E9F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 20 March 2009 20:36:42 Christian Lamparter wrote:
> USB frontend driver code for Atheros AR9170.

It seems lots of patches didn't make it through the list. :(

> +#if 0
> +#include <linux/mutex.h>
> +#define mutex_lock(m) do { mutex_lock(m); __acquire(m); } while (0)
> +#define mutex_unlock(m) do { mutex_unlock(m); __release(m); } while (0)
> +#endif
> +
> +#endif /* __USB_H */

Whoops, debugging code? :)

-- 
Greetings, Michael.
