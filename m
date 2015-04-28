Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42076 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965549AbbD1MzP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 08:55:15 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
References: <1427142300-28051-1-git-send-email-Jes.Sorensen@redhat.com>
	<1427142300-28051-2-git-send-email-Jes.Sorensen@redhat.com>
	<87383kps0o.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 28 Apr 2015 15:55:08 +0300
In-Reply-To: <87383kps0o.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Tue, 28 Apr 2015 11:37:59 +0300")
Message-ID: <87oam876qb.fsf@kamboji.qca.qualcomm.com> (sfid-20150428_145522_701046_93396FE5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> And I pushed this to wireless-drivers-next.git pending branch so that
> kbuild will run it's tests with this driver.

There was one warning from kbuild, but I didn't check if it's just a
false warning or what:

drivers/net/wireless/rtl8xxxu.c: In function 'rtl8723a_phy_lc_calibrate':
drivers/net/wireless/rtl8xxxu.c:2457: warning: 'rf_amode' may be used uninitialized in this function

-- 
Kalle Valo
