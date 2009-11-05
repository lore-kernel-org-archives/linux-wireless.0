Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:20504 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960AbZKESxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2009 13:53:45 -0500
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 24/41] rt2800usb: convert to use struct rt2800_ops methods
Date: Thu, 5 Nov 2009 19:53:47 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173453.28463.94062.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173453.28463.94062.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911051953.47346.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800usb: convert to use struct rt2800_ops methods
> 
> Add chipset registers access abstraction layer and prepare for later
> code unification.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
