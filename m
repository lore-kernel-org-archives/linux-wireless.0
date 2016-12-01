Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56992 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbcLAMZU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 07:25:20 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/1] rtl8xxxu: Work around issue with 8192eu and 8723bu devices
 not reconnecting
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161129235902.11882-2-Jes.Sorensen@redhat.com>
References: <20161129235902.11882-2-Jes.Sorensen@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, briselec@gmail.com
Message-Id: <20161201122445.DBFAD6155C@smtp.codeaurora.org> (sfid-20161201_132524_085121_09D530BE)
Date: Thu,  1 Dec 2016 12:24:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> The H2C MEDIA_STATUS_RPT command for some reason causes 8192eu and
> 8723bu devices not being able to reconnect.
> 
> Reported-by: Barry Day <briselec@gmail.com>
> Cc: <stable@vger.kernel.org> #4.8+
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

c59f13bbead4 rtl8xxxu: Work around issue with 8192eu and 8723bu devices not reconnecting

-- 
https://patchwork.kernel.org/patch/9453251/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
