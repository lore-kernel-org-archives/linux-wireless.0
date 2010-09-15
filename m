Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:42998 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415Ab0IOVMB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 17:12:01 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 14:11:55 -0700
Date: Wed, 15 Sep 2010 14:11:59 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@infradead.org" <mcgrof@infradead.org>
Subject: Re: [PATCH 3/3] compat-wirelsss: add carl9170
Message-ID: <20100915211159.GB1734@tux>
References: <1284583415-11506-1-git-send-email-hauke@hauke-m.de>
 <1284583415-11506-3-git-send-email-hauke@hauke-m.de>
 <201009152250.56676.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <201009152250.56676.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 15, 2010 at 01:50:56PM -0700, Christian Lamparter wrote:
> On Wednesday 15 September 2010 22:43:35 Hauke Mehrtens wrote:
> > This patch adds upport for carl9170.
> > 
> > Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> NACK
> 
> usb_get_from_anchor is not thread-safe on older kernel.
> See details:
> 
> https://patchwork.kernel.org/patch/118946/

Why is this not a stable fix? And for what kernel was this patch
merged for?

  Luis
