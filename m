Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40318 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbcF2P4o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 11:56:44 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/8] wireless: airo: rename 'register' variable
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160616135245.3198419-1-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	Ondrej Zary <linux@rainbow-software.org>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20160629155643.6DD4B61372@smtp.codeaurora.org> (sfid-20160629_175712_029614_14A6F0CA)
Date: Wed, 29 Jun 2016 15:56:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:
> 'register' is a keyword in C and cannot be used in place of a
> variable name, as shown by this -Wextra warning:
> 
> drivers/net/wireless/cisco/airo.c:1105:29: error: 'register' is not at beginning of declaration [-Werror=old-style-declaration]
> 
> This replaces the 'register' keyword with a 'reg' identifier in
> the declaration, which matches the definition and has the intended
> meaning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, 3 patches applied to wireless-drivers-next.git:

88e97c32068f wireless: airo: rename 'register' variable
2a063835ce7c wireless: brcmsmac: fix old-style declaration
6f07e0f12a57 wireless: ipw2200: fix old-style declaration

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9180951/

