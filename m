Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353Ab1BGPJo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 10:09:44 -0500
Date: Mon, 7 Feb 2011 16:08:44 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, george0505@realtek.com,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/6] rtlwifi: rtl8192ce: Refactor rtl8192ce/dm
Message-ID: <20110207150843.GD2319@redhat.com>
References: <4d4eec0a.FzqEp5Xeq+3I1Pmn%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4d4eec0a.FzqEp5Xeq+3I1Pmn%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 06, 2011 at 12:44:26PM -0600, Larry Finger wrote:
> To reuse as much code as possible when adding additional drivers to the
> rtlwifi tree, the common parts of various routines are moved to
> drivers/net/wireless/rtlwifi.
Great!

> This patch does that for the version of
> dm.{h,c} used by rtl8192ce.

But what "dm" mean? 

struct rtl_dm {
        /*PHY status for DM */

does not tell much. Can we get some comments what for is this
code?

