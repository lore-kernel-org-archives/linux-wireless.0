Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:36706 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbXI0Rww (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 13:52:52 -0400
Received: by nf-out-0910.google.com with SMTP id g13so2286936nfb
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2007 10:52:51 -0700 (PDT)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] rfkill: Fix documentation typos
Date: Thu, 27 Sep 2007 20:07:02 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200709271442.42808.mb@bu3sch.de>
In-Reply-To: <200709271442.42808.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709272007.02900.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 27 September 2007, Michael Buesch wrote:
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> Index: wireless-2.6/include/linux/rfkill.h
> ===================================================================
> --- wireless-2.6.orig/include/linux/rfkill.h	2007-09-25 21:41:11.000000000 +0200
> +++ wireless-2.6/include/linux/rfkill.h	2007-09-27 14:41:31.000000000 +0200
> @@ -29,9 +29,9 @@
>  
>  /**
>   * enum rfkill_type - type of rfkill switch.
> - * RFKILL_TYPE_WLAN: switch is no a Wireless network devices.
> - * RFKILL_TYPE_BlUETOOTH: switch is on a bluetooth device.
> - * RFKILL_TYPE_IRDA: switch is on an infrared devices.
> + * RFKILL_TYPE_WLAN: switch is on a 802.11 wireless network device.
> + * RFKILL_TYPE_BLUETOOTH: switch is on a bluetooth device.

Ack on the above 2 changes

> + * RFKILL_TYPE_IRDA: switch is on an infrared device.

RFKILL_TYPE_IRDA has been removed in the net-2.6.24 tree.

Ivo


