Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:47100 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbZHTUHN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 16:07:13 -0400
Received: by qw-out-2122.google.com with SMTP id 8so101612qwh.37
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2009 13:07:14 -0700 (PDT)
Message-ID: <4A8DAD1D.7090608@gmail.com>
Date: Thu, 20 Aug 2009 16:07:57 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: dwmw2@infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] atheros: add ar9170.fw 1-stage firmware
References: <1250793627-22396-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250793627-22396-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> This adds support for ar9170 for using a 1-stage firmware.
> This means only 1 firmware file is required. AVM Fritz
> devices require this.
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>
> Here is a resend, noticed today this wasn't yet in the tree.
>
>   
Last I tested this firmware it didn't seem to function nearly as well as 
the 2 stage firmware, and if present, the 1 stage overrides the 2 
stage.  Is this an improved version? Does this work properly in your 
testing?

Thanks,
Rick
>  ar9170.fw |  Bin 0 -> 15960 bytes
>  1 files changed, 0 insertions(+), 0 deletions(-)
>  create mode 100644 ar9170.fw
>
> diff --git a/ar9170.fw b/ar9170.fw
> new file mode 100644
> index 0000000000000000000000000000000000000000..f3d9415c2fd388b7a384664d401761bfa15e6fad
> GIT binary patch
> literal 15960
> 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
> TF|=44=kEPU67Hq{XQ}@LU)`|g
>
> literal 0
> HcmV?d00001
>
>   

