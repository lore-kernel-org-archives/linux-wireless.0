Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9394 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbcEIK2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 06:28:43 -0400
From: "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>
To: Archisman Maitra <archisman001@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/4] ath10k: Enable support for QCA9984
Date: Mon, 9 May 2016 10:28:32 +0000
Message-ID: <57306645.2060600@qti.qualcomm.com> (sfid-20160509_122846_079568_5B78F1C0)
References: <1461164356-9158-1-git-send-email-vthiagar@qti.qualcomm.com>
 <1461164356-9158-5-git-send-email-vthiagar@qti.qualcomm.com>
 <loom.20160509T113952-8@post.gmane.org>
In-Reply-To: <loom.20160509T113952-8@post.gmane.org>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 09 May 2016 03:16 PM, Archisman Maitra wrote:
>
>
> The firmware crashes on applying this patch.. On examining the kernel OOPs,
> I have found out that that ath10k_bmi_execute in
> drivers/net/wireless/ath/ath10k/core.c when called goes in a loop until
> timeout occurs after which it eventually crashes. This is called from
> ath10k_core_get_board_id_from_otp in
> drivers/net/wireless/ath/ath10k/core.c . As per my understanding, the
> binaries of QCA99X0 that I have used for QCA9984 is not the correct one.
> Could you clarify?

Yes, the firmware binaries are different for QCA99X0 and QCA9984.

Vasanth