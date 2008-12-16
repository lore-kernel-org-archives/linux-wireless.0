Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gw-instruments.de ([82.144.60.34]:41812 "EHLO
	redbean.intranet.gw-instruments.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754080AbYLPQ1v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 11:27:51 -0500
Date: Tue, 16 Dec 2008 16:56:47 +0100 (CET)
From: Peter Wippich <pewi@gw-instruments.de>
To: Colin McCabe <colin@cozybit.com>
cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	Andrey Yurovsky <andrey@cozybit.com>
Subject: Re: [PATCH 0/3] libertas: driver for GSPI devices
In-Reply-To: <1229398052-27465-1-git-send-email-colin@cozybit.com>
Message-ID: <Pine.LNX.4.63.0812161654310.7559@redbean.intranet.gw-instruments.de> (sfid-20081216_172754_776339_9C5ABF62)
References: <1229398052-27465-1-git-send-email-colin@cozybit.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi Colin,

> This patch series adds support for GSPI devices to libertas.
> These devices are found in some embedded systems. We used a blackfin-based
> board for development.
> 
> Since the blackfin has specific alignment requirements, this patch set 
> includes  alignment fixes.

Thanks for this one. As you mentioned somewhere else SPI Firmware for 8686 
is not publicly available. However, can you tell me with which firmware 
Version you tested this ?? 

Thank you and best regards, 

Peter 


|       Peter Wippich                   Voice: +49 30 46776411          |
|       G&W Instruments GmbH            fax:   +49 30 46776419          |
|       Gustav-Meyer-Allee 25, Geb. 12  Email: pewi@gw-instruments.de   |
|       D-13355 Berlin  / Germany                                       |

