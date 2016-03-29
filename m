Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:33139 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbcC2MqC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 08:46:02 -0400
Received: by mail-lf0-f41.google.com with SMTP id g124so8494233lfg.0
        for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2016 05:46:00 -0700 (PDT)
Subject: Re: [PATCH 15/16] wcn36xx: don't pad beacons for mesh
To: Bjorn Andersson <bjorn.andersson@linaro.org>,
	Eugene Krasnikov <k.eugene.e@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <1459231593-360-1-git-send-email-bjorn.andersson@linaro.org>
 <1459231593-360-16-git-send-email-bjorn.andersson@linaro.org>
Cc: wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jason Mobarak <jam@cozybit.com>,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <56FA7905.80902@cogentembedded.com> (sfid-20160329_144629_026185_8764B53C)
Date: Tue, 29 Mar 2016 15:45:57 +0300
MIME-Version: 1.0
In-Reply-To: <1459231593-360-16-git-send-email-bjorn.andersson@linaro.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 3/29/2016 9:06 AM, Bjorn Andersson wrote:

> From: Jason Mobarak <jam@cozybit.com>
>
> Patch "wcn36xx: Pad TIM PVM if needed" has caused a regression in mesh

    scripts/checkpatch.pl now enforces the specific commit citing format, i.e. 
<12-digit SHA1> ("<commit summary>").

> beaconing.  The field tim_off is always 0 for mesh mode, and thus
> pvm_len (referring to the TIM length field) and pad are both incorrectly
> calculated.  Thus, msg_body.beacon_length is incorrectly calculated for
> mesh mode. Fix this.
>
> Signed-off-by: Jason Mobarak <jam@cozybit.com>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>

    You might want to add the Fixes: tag.

[...]

MBR, Sergei

