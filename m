Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51704 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751880AbdHHLxW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 07:53:22 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] rtlwifi: constify rate_control_ops structure
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1502082051-4904-1-git-send-email-bhumirks@gmail.com>
References: <1502082051-4904-1-git-send-email-bhumirks@gmail.com>
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: julia.lawall@lip6.fr, Larry.Finger@lwfinger.net,
        chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bhumika Goyal <bhumirks@gmail.com>
Message-Id: <20170808115322.4155160209@smtp.codeaurora.org> (sfid-20170808_135341_349589_CEF4A7C9)
Date: Tue,  8 Aug 2017 11:53:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bhumika Goyal <bhumirks@gmail.com> wrote:

> rate_control_ops structure is only passed as an argument to the
> function ieee80211_rate_control_{register/unregister}. This argument
> is of type const, so declare the structure as const.
> 
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

cb1b82625de7 rtlwifi: constify rate_control_ops structure

-- 
https://patchwork.kernel.org/patch/9884393/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
