Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45266 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbbFILYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 07:24:52 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Brent Taylor <motobud@gmail.com>
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath6kl: Fix multiple clients associating in AP mode
References: <1431146307-6442-1-git-send-email-motobud@gmail.com>
Date: Tue, 09 Jun 2015 14:24:46 +0300
In-Reply-To: <1431146307-6442-1-git-send-email-motobud@gmail.com> (Brent
	Taylor's message of "Fri, 8 May 2015 23:38:27 -0500")
Message-ID: <878ubtf7k1.fsf@kamboji.qca.qualcomm.com> (sfid-20150609_132456_417146_C768EB2D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brent Taylor <motobud@gmail.com> writes:

> When one client is associated and connected to an ar6003 hw version
> 2.0 with firmware 3.1.1.149, and another client tries to connect, the
> first client's MAC address is lost in the station list because the
> "aid" is always "1".  The structure "wmi_connect_event" has the "aid"
> as the second byte in the message, but it should be the first byte.
>
> This patch has been tested with linux-3.10.40
>
> Signed-off-by: Brent Taylor <motobud@gmail.com>

Thanks, applied to ath.git.

-- 
Kalle Valo
