Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:35948 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbcDDMZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2016 08:25:54 -0400
Received: by mail-lb0-f180.google.com with SMTP id qe11so158408316lbc.3
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2016 05:25:54 -0700 (PDT)
Subject: Re: [PATCH v2 10/15] wcn36xx: Copy all members in config_sta v1
 conversion
To: Bjorn Andersson <bjorn.andersson@linaro.org>,
	Eugene Krasnikov <k.eugene.e@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <1459721806-11817-1-git-send-email-bjorn.andersson@linaro.org>
 <1459721806-11817-10-git-send-email-bjorn.andersson@linaro.org>
Cc: Pontus Fuchs <pontus.fuchs@gmail.com>, wcn36xx@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <57025D50.70505@cogentembedded.com> (sfid-20160404_142617_452292_902C7C22)
Date: Mon, 4 Apr 2016 15:25:52 +0300
MIME-Version: 1.0
In-Reply-To: <1459721806-11817-10-git-send-email-bjorn.andersson@linaro.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/4/2016 1:16 AM, Bjorn Andersson wrote:

> From: Pontus Fuchs <pontus.fuchs@gmail.com>
>
> When converting to version 1 of the config_sta struct not all
> members where copied. This fixes the problem of multicast frames

    Were.

> not being delivered on an encrypted network.
>
> Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
[...]

MBR, Sergei

