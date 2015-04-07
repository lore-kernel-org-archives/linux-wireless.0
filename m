Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32958 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbbDGRJz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2015 13:09:55 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtlwifi: Add encryption argument in rtl_is_special_data for
 checkingDHCP packet.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1427469759-21549-1-git-send-email-ap420073@gmail.com>
To: Taehee Yoo <ap420073@gmail.com>
Cc: Larry.Finger@lwfinger.net, ap420073@gmail.com,
	linux-wireless@vger.kernel.org
Message-Id: <20150407170954.DE80E140CFC@smtp.codeaurora.org> (sfid-20150407_191000_136475_0B7E5EB3)
Date: Tue,  7 Apr 2015 17:09:54 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> rtl8192cu can't connect to AP after physical reconnect.
> according to dmesg, that problem's cause was DHCP timeout.
> 
> rtl_is_special_data function checks packet type for adjusting rate.
> when that function is called from _rtl_rc_get_highest_rix, it can not
> calculate offset correctly. so i add argument is_encn in rtl_is_special_data.
> is_enc variable mean that iv header is added in skb parameter.
> 
> i test only rtl8192cu chipset. because i doesn't have other rtlwifi chipsets.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
