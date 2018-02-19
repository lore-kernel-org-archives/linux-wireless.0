Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:42278 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752218AbeBSD1a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Feb 2018 22:27:30 -0500
Received: by mail-pf0-f173.google.com with SMTP id t15so853297pfh.9
        for <linux-wireless@vger.kernel.org>; Sun, 18 Feb 2018 19:27:30 -0800 (PST)
Date: Sun, 18 Feb 2018 19:27:27 -0800
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Ramon Fried <rfried@codeaurora.org>
Cc: kvalo@codeaurora.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wcn36xx: reduce verbosity of drivers messages
Message-ID: <20180219032727.GI93895@bjorns-mbp-2.lan> (sfid-20180219_042734_532887_BC359F56)
References: <20180217202510.13707-1-rfried@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180217202510.13707-1-rfried@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat 17 Feb 12:25 PST 2018, Ramon Fried wrote:

> Whenever the WLAN interface is started the FW
> version and caps are printed, this info should appear as
> debug info.
> 
> Signed-off-by: Ramon Fried <rfried@codeaurora.org>

Looks reasonable,

Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn
