Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26712 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab2GKQvk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 12:51:40 -0400
From: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ortiz, Samuel" <samuel.ortiz@intel.com>,
	linux-wimax <linux-wimax@intel.com>,
	"wimax@linuxwimax.org" <wimax@linuxwimax.org>
Subject: RE: [RFC 1/2] i2400m: remove SDIO device support
Date: Wed, 11 Jul 2012 16:50:27 +0000
Message-ID: <3A78FAA0EC814D4B8ECC99B3AB32B33208141AC2@fmsmsx110.amr.corp.intel.com> (sfid-20120711_185149_894844_B3D4A564)
References: <1341952049-32193-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1341952049-32193-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: John W. Linville [mailto:linville@tuxdriver.com]
> 
> From: "John W. Linville" <linville@tuxdriver.com>
> 
> SDIO support in this driver was intended to support the iwmc3200
> device.  This hardware never became available to normal humans.
> Leaving this driver imposes unwelcome maintenance costs for no clear
> benefit.
> 
> Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> If there are no objections, I'll push this series through the
> wireless-next tree along with the iwmc3200wifi removal.

Acked-by: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
