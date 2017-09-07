Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42822 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754073AbdIGI7F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Sep 2017 04:59:05 -0400
Message-ID: <1504774743.6177.0.camel@sipsolutions.net> (sfid-20170907_105908_887169_328E35F3)
Subject: Re: using vulnerability ids in patches
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 07 Sep 2017 10:59:03 +0200
In-Reply-To: <7415a11b-398c-69df-b39f-7b985f07112b@broadcom.com> (sfid-20170907_104050_278210_DDE1DE8D)
References: <7415a11b-398c-69df-b39f-7b985f07112b@broadcom.com>
         (sfid-20170907_104050_278210_DDE1DE8D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-09-07 at 10:40 +0200, Arend van Spriel wrote:
> Hi Kalle,
> 
> Due to recent events we were asked about some vulnerability fixes
> for 
> brcmfmac. We already fixed a couple of things without referring to a 
> so-called CVE-ID, which is what people are asking for. Do we have a 
> upstream policy on that? I could not really find anything in the 
> Documentation folder (but I may have overlooked it). Might be worth 
> mentioning in the commit message like with the coverity ids.

Sure.

git log --grep "CVE-"

shows it being done frequently.

johannes
