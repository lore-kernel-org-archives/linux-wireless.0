Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:42898 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752933Ab1CURcy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 13:32:54 -0400
Received: by wyb40 with SMTP id 40so5979944wyb.20
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 10:32:47 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: set the skbuff priority for dummy packets
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>
In-Reply-To: <1300722362-20624-1-git-send-email-coelho@ti.com>
References: <1300722362-20624-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 19:32:07 +0200
Message-ID: <1300728727.2593.241.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-21 at 17:46 +0200, Luciano Coelho wrote:
> The firmware requires dummy packets to be sent using TID 7
> (WL1271_TID_MGMT).  Instead of hardcoding it in the tx_fill_hdr()
> function, set it when creating the packet itself.
> 
> This requires Eliad's fix to set the actual TID in the TX descriptor.
> 
> Cc: Ido Yariv <ido@wizery.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied.

-- 
Cheers,
Luca.

