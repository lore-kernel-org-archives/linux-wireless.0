Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:48860 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab0EKLah (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 07:30:37 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 04:30:37 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19433.16371.429794.802926@gargle.gargle.HOWL>
Date: Tue, 11 May 2010 17:00:59 +0530
To: Dan Carpenter <error27@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 5/5] ath9k_htc: Fix array overflow
In-Reply-To: <20100511112332.GZ27064@bicker>
References: <19433.14244.829946.555964@gargle.gargle.HOWL>
	<20100511112332.GZ27064@bicker>
From: <Sujith.Manoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter wrote:
> On Tue, May 11, 2010 at 04:25:32PM +0530, Sujith.Manoharan@atheros.com wrote:
> > Use ENDPOINT_MAX instead of HST_ENDPOINT_MAX.
> > This fixes a stack corruption issue.
> > 
> > This is based on a patch sent by Dan Carpenter <error27@gmail.com>.
> > 
> 
> There is a bit missing.  The tmp_endpoint variable is always non-null 
> here.  Can you just roll this into your patch?

Sure, patch on its way.

Sujith
