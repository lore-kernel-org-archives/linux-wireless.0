Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:36067 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbbAWRQW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 12:16:22 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] ath9k_htc: Add a module parameter to disable blink
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1421005553-19447-1-git-send-email-hong@topbug.net>
To: Hong Xu <hong@topbug.net>
Cc: linux-wireless@vger.kernel.org, linux@rempel-privat.de,
	Hong Xu <hong@topbug.net>
Message-Id: <20150123171622.1630F14131D@smtp.codeaurora.org> (sfid-20150123_181625_929365_AE17577E)
Date: Fri, 23 Jan 2015 17:16:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Add an option "blink" to enable or disable the LED blink. The default
> value is set to 1 so that existing users would not experience any
> unexpected changes.
> 
> Signed-off-by: Hong Xu <hong@topbug.net>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
