Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:42052 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab3FQJO4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 05:14:56 -0400
Message-ID: <1371460494.3028.7.camel@cumari.coelho.fi> (sfid-20130617_111459_540832_C50E6E33)
Subject: Re: [PATCH 1/4] wlcore: set default_wep_key when configured
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
CC: <linux-wireless@vger.kernel.org>
Date: Mon, 17 Jun 2013 12:14:54 +0300
In-Reply-To: <1368351331-6914-1-git-send-email-eliad@wizery.com>
References: <1368351331-6914-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-05-12 at 12:35 +0300, Eliad Peller wrote:
> From: Yoni Divinsky <yoni.divinsky@ti.com>
> 
> When associating to an AP with WEP set the
> default key upon association by implementing
> the set_deafult_key_idx op.
> 
> Fixes auto-arp sent with wrong key_idx bug.
> 
> Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied this entire series.  Thanks!

--
Luca.

