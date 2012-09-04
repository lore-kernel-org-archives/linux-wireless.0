Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40195 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2IDILG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 04:11:06 -0400
Message-ID: <1346746298.3737.0.camel@jlt4.sipsolutions.net> (sfid-20120904_101112_137395_C537083F)
Subject: Re: [PATCH] ath5k: add support of HW encryption in management frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@lists.ath5k.org
Date: Tue, 04 Sep 2012 10:11:38 +0200
In-Reply-To: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120828_113608_728319_48791C3E)
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20120828_113608_728319_48791C3E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-08-28 at 17:34 +0800, Chun-Yeow Yeoh wrote:
> This patch provides the support of hardware encyrption for
> management frame, including the support of AES CMAC. This
> patch is tested with the following chipsets:
> - AR5213A
> - AR5413
> - AR2413/AR2414

_How_ did you test this? Did you test that management frames are
properly encrypted using AES CCM, and not mangled when decrypted? That's
the concern, see my other mail to Christian on his carl9170 patch.

johannes

