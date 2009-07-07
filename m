Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40978 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758170AbZGGQPv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 12:15:51 -0400
Date: Tue, 7 Jul 2009 12:04:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] p54: fix beacon template dtim IE corruption
Message-ID: <20090707160431.GB2768@tuxdriver.com>
References: <200907041824.07655.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <200907041824.07655.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 04, 2009 at 06:24:07PM +0200, Christian Lamparter wrote:
> This patch fixes a regression that sneaked in with 
> "[PATCH] p54: re-enable power save feature".
> When p54_beacon_format_ie_tim was divided up
> and rewritten to use skb_* macros.

I don't seem to have any record of that patch, and this one doesn't
apply after the reorganization series from Larry (which is strange,
since this file didn't seem to exist before that series)...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
