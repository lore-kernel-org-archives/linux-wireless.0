Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:44786 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbZKHOUs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 09:20:48 -0500
Received: by ey-out-2122.google.com with SMTP id 25so8024eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 06:20:52 -0800 (PST)
Message-ID: <4AF6D3C2.4020703@gmail.com>
Date: Sun, 08 Nov 2009 15:20:50 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 4/9] rt2800usb: reorganize code in rt2800usb_probe_hw_mode()
References: <20091108133854.23584.86842.sendpatchset@localhost.localdomain> <20091108133916.23584.20632.sendpatchset@localhost.localdomain>
In-Reply-To: <20091108133916.23584.20632.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/09 14:39, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800usb: reorganize code in rt2800usb_probe_hw_mode()
> 
> Move hw_mode information initialization code block before
> HT information initialization one to match the ordering used
> by rt2800pci's rt2800pci_probe_hw_mode().
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
