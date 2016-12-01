Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35960 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751148AbcLAKUs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 05:20:48 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/1] rtl8xxxu: Work around issue with 8192eu and 8723bu devices
 not reconnecting
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161129235902.11882-2-Jes.Sorensen@redhat.com>
References: <20161129235902.11882-2-Jes.Sorensen@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, briselec@gmail.com
Message-Id: <20161201102023.43045614EB@smtp.codeaurora.org> (sfid-20161201_112052_828010_8D2C20B7)
Date: Thu,  1 Dec 2016 10:20:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> The H2C MEDIA_STATUS_RPT command for some reason causes 8192eu and
> 8723bu devices not being able to reconnect.
> 
> Reported-by: Barry Day <briselec@gmail.com>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Like discussed I'll add:

Cc: <stable@vger.kernel.org> #4.8+

-- 
https://patchwork.kernel.org/patch/9453251/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
