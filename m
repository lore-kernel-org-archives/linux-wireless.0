Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f20.google.com ([209.85.220.20]:58329 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbZBCOI6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 09:08:58 -0500
Received: by fxm13 with SMTP id 13so2227202fxm.13
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 06:08:55 -0800 (PST)
Subject: Re: [ath5k-devel] [PATCH 1/5] ath5k: PHY code cleanup
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Nick Kossifidis <mick@madwifi-project.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com
In-Reply-To: <20090131022310.GA3342@makis>
References: <20090131022310.GA3342@makis>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 16:08:50 +0200
Message-Id: <1233670130.16539.5.camel@maxim-laptop> (sfid-20090203_150907_144808_9F02F38F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just tried your 5 patches, as they could fix hangs in the device,
that I experience occasionally, when resuming my aspire one from ram.

I applied the patches, and I got very unstable system, that tended to
hang even before X.

When it didn't hang, I tried suspend to ram cycle, but it hanged then.


Best regards,
	Maxim Levitsky

