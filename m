Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46792 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab3JKNoV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 09:44:21 -0400
Message-ID: <1381499056.14293.19.camel@jlt4.sipsolutions.net> (sfid-20131011_154428_745047_7392CFF1)
Subject: Re: [PATCH v3] mac80211: port CCMP to cryptoapi's CCM driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	patches@linaro.org
Date: Fri, 11 Oct 2013 15:44:16 +0200
In-Reply-To: <1381391720-28771-1-git-send-email-ard.biesheuvel@linaro.org> (sfid-20131010_095705_907290_11D45849)
References: <1381391720-28771-1-git-send-email-ard.biesheuvel@linaro.org>
	 (sfid-20131010_095705_907290_11D45849)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-10-10 at 09:55 +0200, Ard Biesheuvel wrote:
> Use the generic CCM aead chaining mode driver rather than a local
> implementation that sits right on top of the core AES cipher.
> 
> This allows the use of accelerated implementations of either
> CCM as a whole or the CTR mode which it encapsulates.

Applied.

johannes

