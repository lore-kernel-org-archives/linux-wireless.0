Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55250 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbZDVUeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 16:34:18 -0400
Received: by fxm2 with SMTP id 2so187680fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 22 Apr 2009 13:34:17 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: luciano.coelho@nokia.com, Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org
Subject: Re: wl12xx: second submission
References: <87hc0gcue2.fsf@litku.valot.fi>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 22 Apr 2009 23:34:15 +0300
In-Reply-To: <87hc0gcue2.fsf@litku.valot.fi> (Kalle Valo's message of "Wed\, 22 Apr 2009 23\:20\:53 +0300")
Message-ID: <87d4b4ctrs.fsf@litku.valot.fi> (sfid-20090422_223423_310441_3B3B88BB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@iki.fi> writes:

> Hi John,
>
> here is the second submission of wl12xx, a driver for TI wl1251 chipset:
>
> http://www.valot.fi/kalle/tmp/wl12xx/20090422/

Hold on. I compiled this only with a merge of linux-omap and
wireless-testing. Because of this I didn't notice that there are mach
includes which won't compile in wireless-testing:

#include <mach/board.h>
#include <mach/board-nokia.h>

But I'm too tired to fix them now, I'll do that tomorrow.

-- 
Kalle Valo
