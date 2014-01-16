Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42284 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbaAPLYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 06:24:52 -0500
Message-ID: <1389871486.4345.2.camel@jlt4.sipsolutions.net> (sfid-20140116_122455_495267_3349F994)
Subject: Re: [PATCH] mac80211: drop unused param 'encrypted' from
 ccmp_special_blocks()
From: Johannes Berg <johannes@sipsolutions.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-wireless@vger.kernel.org, patches@linaro.org
Date: Thu, 16 Jan 2014 12:24:46 +0100
In-Reply-To: <1389870990-3735-1-git-send-email-ard.biesheuvel@linaro.org> (sfid-20140116_121641_864939_B988C0EC)
References: <1389870990-3735-1-git-send-email-ard.biesheuvel@linaro.org>
	 (sfid-20140116_121641_864939_B988C0EC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-16 at 12:16 +0100, Ard Biesheuvel wrote:
> Commit 7ec7c4a9a686 ("mac80211: port CCMP to cryptoapi's CCM driver")
> resulted in the 'encrypted' param of ccmp_special_blocks() to be no
> longer used so it can be dropped from the prototype.

Applied.

johannes

