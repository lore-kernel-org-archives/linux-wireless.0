Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11084 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab0EQG4b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 May 2010 02:56:31 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 16 May 2010 23:56:31 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19440.59578.833265.73504@gargle.gargle.HOWL>
Date: Mon, 17 May 2010 12:26:58 +0530
To: David Woodhouse <dwmw2@infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Update AR9271 firmware.
In-Reply-To: <1274078768.6930.6898.camel@macbook.infradead.org>
References: <19440.58792.695144.835937@gargle.gargle.HOWL>
	<1274078768.6930.6898.camel@macbook.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Woodhouse wrote:
> On Mon, 2010-05-17 at 07:43 +0100, Sujith wrote:
> > Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> > ---
> >  ar9271.fw |  Bin 49280 -> 51280 bytes
> >  1 files changed, 0 insertions(+), 0 deletions(-)
> 
> No changelog, no version number... is this really what you consider to
> be good engineering practice?

Unfortunately, there is no versioning for the firmware.

The list of changes would be fairly large, since the last
firmware release was ~4 months ago. Am not involved in
firmware development, but I'll get a list of changes and
resend the patch. Thanks.

Sujith
