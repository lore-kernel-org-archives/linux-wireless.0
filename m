Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canuck.infradead.org ([209.217.80.40]:46623 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030584AbXC2R7k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 13:59:40 -0400
Subject: Re: [PATCH] bcm43xx: Change initialization for 2050 radios
From: David Woodhouse <dwmw2@infradead.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <460a92d5.+NfCgWddLCeb9ty2%Larry.Finger@lwfinger.net>
References: <460a92d5.+NfCgWddLCeb9ty2%Larry.Finger@lwfinger.net>
Content-Type: text/plain
Date: Thu, 29 Mar 2007 18:22:35 +0100
Message-Id: <1175188955.3122.42.camel@pmac.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-03-28 at 11:07 -0500, Larry Finger wrote:
> This patch implements the changes in the specifications for
> 2050radio_init that were recently posted.

That seems to help performance quite a lot -- although 'rate 11M' still
runs a _lot_ faster than the 24M which the driver seems to settle at by
default, when it's sitting 1m from the AP.

-- 
dwmw2

