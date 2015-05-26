Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57636 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbbEZNrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 09:47:49 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/2] rtlwifi: rtl8192cu: Remove setting REG_BCN_MAX_ERR code
 in_rtl92cu_set_media_status().
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1431162923-5037-1-git-send-email-ap420073@gmail.com>
To: Taehee Yoo <ap420073@gmail.com>
Cc: Larry.Finger@lwfinger.net, ap420073@gmail.com,
	linux-wireless@vger.kernel.org
Message-Id: <20150526104339.A0523141694@smtp.codeaurora.org> (sfid-20150526_154753_498719_E39B645A)
Date: Tue, 26 May 2015 10:43:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Initialization routine set REG_BCN_MAX_ERR to 0xFF.
> also _rtl92cu_set_media_status set REG_BCN_MAX_ERR to same value.
> so i remove this code.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Thanks, 2 patches applied to wireless-drivers-next.git:

dacc7e193985 rtlwifi: rtl8192cu: Remove setting REG_BCN_MAX_ERR code in _rtl92cu_set_media_status().
bfe3d2bf6c23 rtlwifi: rtl8192cu: Remove rtl92c_init_beacon_max_error's parameter

Kalle Valo
