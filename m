Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57796 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752967AbeCMQwr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 12:52:47 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: net/wireless: fix spaces and grammar copy/paste in vendor Kconfig
 help text
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1627081c-ef0c-1d55-ca2e-898f22b98d72@infradead.org>
References: <1627081c-ef0c-1d55-ca2e-898f22b98d72@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-Id: <20180313165247.371B8600C1@smtp.codeaurora.org> (sfid-20180313_175304_142214_6785416C)
Date: Tue, 13 Mar 2018 16:52:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Randy Dunlap <rdunlap@infradead.org> wrote:

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Lots of the wireless driver vendor Kconfig symol help text says
> "questions about  cards." (2 spaces between "about" and "cards")
> 
> Besides dropping one of those spaces, it also needs some other word
> inserted there. Instead of putting each vendor's name there, I chose
> to say "these" cards in all of the Kconfig help text.
> 
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Patch applied to wireless-drivers-next.git, thanks.

a6cf02e6485a net/wireless: fix spaces and grammar copy/paste in vendor Kconfig help text

-- 
https://patchwork.kernel.org/patch/10255933/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
