Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55563 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbbHMMdO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 08:33:14 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [NEXT] rtlwifi: rtl8192c-common: Fix two typos
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1438636553-28465-1-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	David Binderman <dcb314@hotmail.com>
Message-Id: <20150813123314.3695D140630@smtp.codeaurora.org> (sfid-20150813_143318_002401_652982A4)
Date: Thu, 13 Aug 2015 12:33:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> In this driver, two variables are masked by one quantity, and then tested
> against a second number with more bits that the mask. Accordingly, the
> test always fails. To minimize the possibility of such typos, a symbolic
> definition of the mask is created and used.
> 
> The separate load and mask operations are also combined into a single
> statement.
> 
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: David Binderman <dcb314@hotmail.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
