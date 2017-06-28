Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:36339 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751587AbdF1UQg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:16:36 -0400
Received: by mail-qt0-f177.google.com with SMTP id i2so59004418qta.3
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jun 2017 13:16:36 -0700 (PDT)
Subject: Re: [PATCH] ieee80211: update public action codes
To: peter.oh@bowerswilkins.com, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net
Cc: johannes.berg@intel.com
References: <1498601249-8372-1-git-send-email-peter.oh@bowerswilkins.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d9aaa85b-49ac-494e-7979-afc42d309dc4@broadcom.com> (sfid-20170628_221640_598558_FEC4B153)
Date: Wed, 28 Jun 2017 22:16:22 +0200
MIME-Version: 1.0
In-Reply-To: <1498601249-8372-1-git-send-email-peter.oh@bowerswilkins.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28-06-17 00:07, peter.oh@bowerswilkins.com wrote:
> From: Peter Oh <peter.oh@bowerswilkins.com>
> 
> Update Public Action field values as updated in IEEE Std 802.11-2016,
> so that modules/drivers can refer it.

Hi Peter,

I am pretty sure there are a lot of other definitions in the 802.11 spec
that are not in a linux header file. So are you planning on submitting
driver patches using the added definitions. Stuff is mostly added as needed.

Regards,
Arend

> Signed-off-by: Peter Oh <peter.oh@bowerswilkins.com>
> ---
>  include/linux/ieee80211.h | 35 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)
