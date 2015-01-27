Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:45392 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758247AbbA0RwF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 12:52:05 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtlwifi: add support to send beacon frame.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1421827099-17975-1-git-send-email-ap420073@gmail.com>
To: Taehee Yoo <ap420073@gmail.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
	Taehee Yoo <ap420073@gmail.com>
Message-Id: <20150127175205.C3049140CF3@smtp.codeaurora.org> (sfid-20150127_185214_188094_337025E8)
Date: Tue, 27 Jan 2015 17:52:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> In AP mode, beacon frame is necessary to keep connection.
> this patch adds a sending beacon frame routine in initialization routine.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
