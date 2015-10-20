Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:1602 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbbJTEuC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 00:50:02 -0400
Date: Tue, 20 Oct 2015 06:49:57 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [RESEND PATCH] NFC: trf7970a: Add OF match table
Message-ID: <20151020044957.GB9764@zurbaran.home> (sfid-20151020_065032_120646_3998B3E0)
References: <1442394522-12883-1-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442394522-12883-1-git-send-email-javier@osg.samsung.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Javier,

On Wed, Sep 16, 2015 at 11:08:42AM +0200, Javier Martinez Canillas wrote:
> The Documentation/devicetree/bindings/net/nfc/trf7970a.txt DT binding doc
> lists "ti,trf7970a" as a compatible string but the corresponding driver
> does not have an OF match table. Add the table to the driver so the SPI
> core can do an OF style match.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> ---
> 
>  drivers/nfc/trf7970a.c | 7 +++++++
>  1 file changed, 7 insertions(+)
Patch applied, thanks.

Cheers,
Samuel.
