Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36677 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750765AbdHNEsz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Aug 2017 00:48:55 -0400
Received: by mail-pg0-f68.google.com with SMTP id y129so8698388pgy.3
        for <linux-wireless@vger.kernel.org>; Sun, 13 Aug 2017 21:48:55 -0700 (PDT)
Date: Mon, 14 Aug 2017 14:49:03 +1000
From: Barry Day <briselec@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [PATCH v2 1/2] rtlwifi: use debugfs to debug.
Message-ID: <20170814044901.GA12440@testbox> (sfid-20170814_064859_184630_6446CA1E)
References: <20170810164744.9336-1-Larry.Finger@lwfinger.net>
 <20170810164744.9336-2-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170810164744.9336-2-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 10, 2017 at 11:47:43AM -0500, Larry Finger wrote:
> +struct rtl_debgufs_priv {

spelling mistake ?
