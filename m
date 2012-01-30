Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49692 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab2A3Qb3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 11:31:29 -0500
Message-ID: <4F26C5DD.5080500@lwfinger.net> (sfid-20120130_173152_036182_70D8D313)
Date: Mon, 30 Jan 2012 10:31:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: wlanfae@realtek.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] [trivial] rtlwifi: Fix typo in dm.c
References: <1327939568-15687-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1327939568-15687-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/30/2012 10:06 AM, Masanari Iida wrote:
> Correct a spelling "disconnet" to "disconnect" in
> drivers/net/wireless/rtlwifi/rtl8192de/dm.c
> This is a 2nd post version.
> Change subject line as per request.
>
> Signed-off-by: Masanari Iida<standby24x7@gmail.com>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192de/dm.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)

Sorry, but once again, I have to nitpick. I don't think you want the stuff about 
"2nd post version" permanently in the git log. That sort of info should be after 
the first --- and will be available to the maintainer, but stripped off when the 
patch is committed. In addition, resubmits are usually indicated in the subject 
line as "[PATCH V2]", etc. That info is also stripped off in the commit process.

Larry
