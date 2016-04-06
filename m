Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32879 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbcDFSfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 14:35:52 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/2] rtlwifi: rtl8723be: Add antenna select module parameter
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1458153215-25602-2-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@vger.kernel.org>
Message-Id: <20160406183550.EAEED615CF@smtp.codeaurora.org> (sfid-20160406_203600_980439_898F63DC)
Date: Wed,  6 Apr 2016 18:35:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> A number of new laptops have been delivered with only a single antenna.
> In principle, this is OK; however, a problem arises when the on-board
> EEPROM is programmed to use the other antenna connection. The option
> of opening the computer and moving the connector is not always possible
> as it will void the warranty in some cases. In addition, this solution
> breaks the Windows driver when the box dual boots Linux and Windows.
> 
> A fix involving a new module parameter has been developed.  This commit
> adds the new parameter and implements the changes needed for the driver.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org> [V4.0+]

Thanks, 2 patches applied to wireless-drivers-next.git:

c18d8f509571 rtlwifi: rtl8723be: Add antenna select module parameter
baa170229095 rtlwifi: btcoexist: Implement antenna selection

Kalle Valo
