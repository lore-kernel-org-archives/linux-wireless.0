Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab1BUJvo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 04:51:44 -0500
Date: Mon, 21 Feb 2011 10:50:39 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, george0505@realtek.com,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 13/14] rtlwifi: rtl8192cu: Add routine trx
Message-ID: <20110221095037.GA4390@redhat.com>
References: <4d5d90c9.sN3PKFogcRQR8mbQ%Larry.Finger@lwfinger.net>
 <20110218112633.GA2270@redhat.com>
 <4D5EA1D4.9080600@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D5EA1D4.9080600@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 18, 2011 at 10:44:04AM -0600, Larry Finger wrote:
> There are a lot of endian warnings besides the frame_header ones.
> Fixing many of them will require rewriting those macros that you
> mentioned in an earlier message. My efforts on those usually end up
> breaking the drivers
Hmm, but they do not break now ? 

> and I had hoped to defer that effort, but it
> seems that the time has come. While I'm doing that, will you look at
> my first cut at fixing endian issues to make sure I'm doing it
> correctly?

This patch as well your furtner one "[PATCH V2 15/16] rtlwifi:
rtl8192ce: Fix endian warnings" looks fine, thanks.

Stanislaw
