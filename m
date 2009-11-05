Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:48137 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758508AbZKEUdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2009 15:33:12 -0500
Message-ID: <4AF3367D.4050303@gmail.com>
Date: Thu, 05 Nov 2009 21:33:01 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 31/41] rt2800usb: add RXINFO_DESC_SIZE definition
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173547.28463.36376.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173547.28463.36376.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/09 18:35, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800usb: add RXINFO_DESC_SIZE definition
> 
> Add RXINFO_DESC_SIZE definition and use it instead of abusing
> RXD_DESC_SIZE one (TXD_DESC_SIZE and RXD_DESC_SIZE are specific
> to PCI version of the chipset).
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
