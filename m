Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:57492 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab3IPVom (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 17:44:42 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 2/8 V2] rtlwifi: rtl8192de: Fix smatch warnings in rtl8192de/hw.c
References: <1379357722-17687-1-git-send-email-Larry.Finger@lwfinger.net>
	<1379357722-17687-3-git-send-email-Larry.Finger@lwfinger.net>
Date: Tue, 17 Sep 2013 00:44:39 +0300
In-Reply-To: <1379357722-17687-3-git-send-email-Larry.Finger@lwfinger.net>
	(Larry Finger's message of "Mon, 16 Sep 2013 13:55:16 -0500")
Message-ID: <874n9ktpa0.fsf@purkki.adurom.net> (sfid-20130916_234452_882714_9573F816)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> Smatch lists the following:
>   CHECK   drivers/net/wireless/rtlwifi/rtl8192de/hw.c
> drivers/net/wireless/rtlwifi/rtl8192de/hw.c:1200 rtl92de_set_qos() info: ignoring unreachable code.
> drivers/net/wireless/rtlwifi/rtl8192de/hw.c:1200 rtl92de_set_qos() info: ignoring unreachable code.
>
> Dead code is commented out. It has not been deleted in case I find a need for
> it later.

We should not have any commented out code. It's better to remove it and
if it's ever needed it can be found from the git history.

-- 
Kalle Valo
