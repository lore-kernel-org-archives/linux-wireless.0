Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43116 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751975AbdG1Pms (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 11:42:48 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] rtlwifi: Fix memory leak when firmware request fails
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170705142506.GA13562@symbol-HP-ZBook-15>
References: <20170705142506.GA13562@symbol-HP-ZBook-15>
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Message-Id: <20170728154247.9D508609A1@smtp.codeaurora.org> (sfid-20170728_174251_707143_2A8CCFFE)
Date: Fri, 28 Jul 2017 15:42:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Souptick Joarder <jrdr.linux@gmail.com> wrote:

> This patch will fix memory leak when firmware request fails
> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers-next.git, thanks.

f2764f61fa10 rtlwifi: Fix memory leak when firmware request fails

-- 
https://patchwork.kernel.org/patch/9826619/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
