Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34277 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbbHRF5W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 01:57:22 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl8192cu: remove duplicated routine in hw.c and mac.c
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1427730932-4364-1-git-send-email-ap420073@gmail.com>
To: Taehee Yoo <ap420073@gmail.com>
Cc: Larry.Finger@lwfinger.net, ap420073@gmail.com,
	linux-wireless@vger.kernel.org
Message-Id: <20150818055721.D3AEB1402F7@smtp.codeaurora.org> (sfid-20150818_075729_082181_FB99F4D8)
Date: Tue, 18 Aug 2015 05:57:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> rtl92c_set_xxx_filter is same routine with rtl92cu_set_hw_reg.
> so i remove those functions that are rtl92c_set_xxx_filter.
> (rtl92c_get_xxx_filter is also same reason.)
> also i add code updating struct rtl_mac member variable in the
> rtl92cu_set_hw_reg.
> after that, no more _update_mac_setting is not useful. thus i remove that.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
