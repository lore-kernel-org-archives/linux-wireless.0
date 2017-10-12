Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38237 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751350AbdJLLd4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 07:33:56 -0400
Date: Thu, 12 Oct 2017 13:34:05 +0200
From: Greg KH <greg@kroah.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: stable@vger.kernel.org, linux-wireless@vger.kernel.org,
        Kevin Cernekee <cernekee@chromium.org>
Subject: Re: [PATCH] brcmfmac: add length check in
 brcmf_cfg80211_escan_handler()
Message-ID: <20171012113405.GA27073@kroah.com> (sfid-20171012_133359_798285_383299AA)
References: <1507802052-14654-1-git-send-email-arend.vanspriel@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1507802052-14654-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 12, 2017 at 11:54:12AM +0200, Arend van Spriel wrote:
> commit 17df6453d4be17910456e99c5a85025aa1b7a246 upstream.
> 
> Upon handling the firmware notification for scans the length was
> checked properly and may result in corrupting kernel heap memory
> due to buffer overruns. This fix addresses CVE-2017-0786.
> 
> Cc: Kevin Cernekee <cernekee@chromium.org>
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
> Hi, Greg
> 
> This backport for stable-4.4 has been compile tested on x86_64 on
> linux-4.4.y branch in the stable repo. Apparently I only checked
> that the patch applied on 4.4. Lesson learned.

No worries, thanks for the patch.

greg k-h
