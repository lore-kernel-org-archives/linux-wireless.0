Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:29493 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbXJZNi0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 09:38:26 -0400
Received: by ug-out-1314.google.com with SMTP id z38so675022ugc
        for <linux-wireless@vger.kernel.org>; Fri, 26 Oct 2007 06:38:24 -0700 (PDT)
Message-ID: <d120d5000710260638i4f5d2780ied5bcaabebbaf137@mail.gmail.com> (sfid-20071026_143834_130419_F5C4535D)
Date: Fri, 26 Oct 2007 09:38:23 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH] Remove pointless casts from void pointers,
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
	rmk@arm.linux.org.uk, kernel@wantstofly.org, tony.luck@intel.com,
	jwboyer@linux.vnet.ibm.com, benh@kernel.crashing.org,
	paulus@samba.org, netdev@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-wireless@vger.kernel.org, bryan.wu@analog.com,
	adaplas@gmail.com
In-Reply-To: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/26/07, Jeff Garzik <jeff@garzik.org> wrote:
>  drivers/input/touchscreen/h3600_ts_input.c |    4 ++--

Acked-by: Dmitry Torokhov <dtor@mail.ru>

-- 
Dmitry
