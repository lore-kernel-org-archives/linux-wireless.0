Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40662 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755462AbdEROHL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 10:07:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2, 1/4] rtlwifi: btcoex: Remove 21a 1ant configuration parameter
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170504184701.16560-2-Larry.Finger@lwfinger.net>
References: <20170504184701.16560-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Message-Id: <20170518140705.C678B60F67@smtp.codeaurora.org> (sfid-20170518_160732_130012_F0D10A7A)
Date: Thu, 18 May 2017 14:07:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> In file halbtc8821a1ant.c, there are directives that depend on an
> undocumented configuration parameter BT_AUTO_REPORT_ONLY_8821A_1ANT
> that cannot be set from Kconfig. This parameter is replaced by a
> boolean in the main structure used by all routines. It still cannot
> be changed dynamically, but it is easier to document.
> 
> Using a suggestion from Realtek, the auto report is turned on with this
> patch.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Pkshih <pkshih@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

4 patches applied to wireless-drivers-next.git, thanks.

aef9ae460742 rtlwifi: btcoex: Remove 21a 1ant configuration parameter
f66509e3d7c2 rtlwifi: btcoex: Remove 23b 1ant configuration parameter
d6a82054f27b rtlwifi: btcoex: Remove 23b 2ant configuration parameter
436e9c1bb77e rtlwifi: btcoex: Remove 92e 2ant configuration parameter

-- 
https://patchwork.kernel.org/patch/9712523/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
