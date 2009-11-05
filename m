Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:58636 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031AbZKEUjo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2009 15:39:44 -0500
Message-ID: <4AF33812.8080401@gmail.com>
Date: Thu, 05 Nov 2009 21:39:46 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 34/41] rt2x00: add support for different chipset interfaces
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173610.28463.4270.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173610.28463.4270.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/09 18:36, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2x00: add support for different chipset interfaces
> 
> Enhance rt2x00 infrastructure by adding explicit information
> about used chipset interface to struct rt2x00_chip.
> 
> The new field will be used by rt2800 drivers for rt2800 library.
> 
> Also add commonly used rt2x00_intf_is_pci() and rt2x00_intf_is_usb()
> helpers to make code easier to read (noticed by Ivo van Doorn).
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
