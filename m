Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60251 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbbGUN4a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 09:56:30 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: wlcore: sdio: return correct error code
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1435826089-83970-1-git-send-email-poggi.raph@gmail.com>
To: =?utf-8?q?Rapha=C3=ABl_Poggi?= <poggi.raph@gmail.com>
Cc: luca@coelho.fi, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, Raphael Poggi <poggi.raph@gmail.com>
Message-Id: <20150721135629.B3B78141314@smtp.codeaurora.org> (sfid-20150721_155700_457769_2B5B6A26)
Date: Tue, 21 Jul 2015 13:56:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> When wlcore_probe_of failed, return the correct error code instead of ENOMEM
> 
> Signed-off-by: Raphaël Poggi <poggi.raph@gmail.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
