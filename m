Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59679 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbbEZOCt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 10:02:49 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/5] rtlwifi: Update regulatory database
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1431725583-7324-2-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Shao Fu <shaofu@realtek.com>,
	netdev@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
Message-Id: <20150526105708.78A79141726@smtp.codeaurora.org> (sfid-20150526_160300_543324_F7533FF0)
Date: Tue, 26 May 2015 10:57:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Shao Fu <shaofu@realtek.com>
> 
> Driver rtlwifi maintains its own regulatory information, The Chrome Autotest
> (https://www.chromium.org/chromium-os/testing/autotest-user-doc)
> showed some errors. This patch adds the necessary information for rtlwifi.
> 
> Signed-off-by: Shao Fu <shaofu@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, 5 patches applied to wireless-drivers-next.git:

02b5fffbe9e0 rtlwifi: Update regulatory database
852ce7805638 rtlwifi: rtl8188ee: Apply the new regulatory information
5620302484d4 rtlwifi: rtl8192ee: Apply the regulatory changes to driver
b23cd22d3923 rtlwifi: rtl8723be: Update driver for regulatory changes
d10101a60372 rtlwifi: rtl8821ae: Fix problem with regulatory information

Kalle Valo
