Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.233]:60678 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbXK1Fpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 00:45:49 -0500
Received: by nz-out-0506.google.com with SMTP id s18so962713nze
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 21:45:48 -0800 (PST)
Message-ID: <43e72e890711272145l8f31864u3f798e020ccaddfb@mail.gmail.com> (sfid-20071128_054554_173213_F278CA04)
Date: Wed, 28 Nov 2007 00:45:48 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: [PATCH 1/1] ath5k: more consistent debugging
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com
In-Reply-To: <1196077433-12358-2-git-send-email-bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1196077433-12358-1-git-send-email-bruno@thinktube.com>
	 <1196077433-12358-2-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 26, 2007 6:43 AM, Bruno Randolf <bruno@thinktube.com> wrote:

> diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
> new file mode 100644
> index 0000000..7427506
> --- /dev/null
> +++ b/drivers/net/wireless/ath5k/debug.c

etc

> +#if ATH5K_DEBUG

This would be better as a CONFIG_ATH5K_DEBUG. Also the patch doesn't
apply cleanly anymore. That's probably my fault for the delay in
response and apologies for that. Other than that it looks fine. Sorry
I couldn't test it. I'll try to amend it and test it.

  Luis
