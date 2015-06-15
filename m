Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51233 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbbFOJiw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 05:38:52 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [V2] rtlwifi: rtl8192c: Add init codes for "fw_version"
 and"fw_subversion".
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1433684016-24340-1-git-send-email-ap420073@gmail.com>
To: Taehee Yoo <ap420073@gmail.com>
Cc: Larry.Finger@lwfinger.net, ap420073@gmail.com,
	linux-wireless@vger.kernel.org
Message-Id: <20150615093851.5F08714086F@smtp.codeaurora.org> (sfid-20150615_113855_610014_C652E0F3)
Date: Mon, 15 Jun 2015 09:38:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The variable "fw_version" is used in the _ResetDigitalProcedure1().
> but It is not initialized. so I add init codes for "fw_version" and
> "fw_subversion".
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
