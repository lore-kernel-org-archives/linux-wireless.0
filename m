Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50792 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbcD0MzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2016 08:55:10 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Steve deRosier <derosier@gmail.com>
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org,
	Steve deRosier <steve.derosier@lairdtech.com>
Subject: Re: [PATCH] ath6kl: Add ability to set debug uart baud rate
References: <1460765986-12698-1-git-send-email-steve.derosier@lairdtech.com>
Date: Wed, 27 Apr 2016 15:55:04 +0300
In-Reply-To: <1460765986-12698-1-git-send-email-steve.derosier@lairdtech.com>
	(Steve deRosier's message of "Fri, 15 Apr 2016 17:19:46 -0700")
Message-ID: <87a8kfw6s7.fsf@kamboji.qca.qualcomm.com> (sfid-20160427_145516_159104_5FC0732A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Steve deRosier <derosier@gmail.com> writes:

> It's useful to permit the customization of the debug uart baud rate. Enable
> this and send down the value to the chip if we're enabling debug.
>
> Signed-off-by: Steve deRosier <steve.derosier@lairdtech.com>

Applied, thanks.

-- 
Kalle Valo
