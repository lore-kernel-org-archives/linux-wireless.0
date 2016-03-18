Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0078.hostedemail.com ([216.40.44.78]:52602 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751271AbcCRDhm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 23:37:42 -0400
Message-ID: <1458272258.9556.46.camel@perches.com> (sfid-20160318_043804_079261_8507BFED)
Subject: Re: [PATCH] rtlwifi: btcoexist: Convert BTC_PRINTK to btc_<foo>_dbg
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-kernel@vger.kernel.org
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Thu, 17 Mar 2016 20:37:38 -0700
In-Reply-To: <56EB6DD9.3000300@lwfinger.net>
References: <4672f9efb37df545ae504d51ca626bf34237fa63.1458258337.git.joe@perches.com>
	 <56EB6DD9.3000300@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-03-17 at 21:54 -0500, Larry Finger wrote:
> On 03/17/2016 07:00 PM, Joe Perches wrote:
> > Use a more common logging style.

[ 300K+ quote without comment ]

> Joe,

Hi Larry.

> The patch looks good, but it has conflict in 
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c with the patch 
> [PATCH 2/2] rtlwifi: btcoexist: Implement antenna selection that I submitted 
> yesterday.

No worries, it shouldn't be applied during the
merge window anyway.

The conflict is trivially resolved after the
merge window is over.

cheers, Joe
