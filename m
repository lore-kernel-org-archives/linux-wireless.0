Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:62198 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbZKHOhR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 09:37:17 -0500
Received: by ewy3 with SMTP id 3so2397645ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 06:37:21 -0800 (PST)
Message-ID: <4AF6D79F.1060009@gmail.com>
Date: Sun, 08 Nov 2009 15:37:19 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 7/9] rt2800usb: fix RX descriptor naming
References: <20091108133854.23584.86842.sendpatchset@localhost.localdomain> <20091108133940.23584.22577.sendpatchset@localhost.localdomain>
In-Reply-To: <20091108133940.23584.22577.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/09 14:39, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800usb: fix RX descriptor naming
> 
> Rename RXD_W0_* defines to RXINFO_W0_* ones to match naming
> used for TX descriptor and by the vendor driver.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
