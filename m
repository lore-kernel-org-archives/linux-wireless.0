Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50538 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab3BMI64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 03:58:56 -0500
Message-ID: <1360745930.8868.2.camel@jlt4.sipsolutions.net> (sfid-20130213_095901_633744_AB43109C)
Subject: Re: [PATCH] iw: Add VHT info in link query
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 13 Feb 2013 09:58:50 +0100
In-Reply-To: <20130213043833.GA842@markyou.marvell.com>
References: <20130213043833.GA842@markyou.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-13 at 10:08 +0530, Yogesh Ashok Powar wrote:
> Show VHT mcs, nss and bw, if present, in
> iw dev link.

Applied, thanks. I also fixed "Mhz" to "MHz" in the new & existing code.

johannes

