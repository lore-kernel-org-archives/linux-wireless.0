Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2974 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933238Ab1IONqo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 09:46:44 -0400
Message-ID: <4E7201BE.704@qca.qualcomm.com> (sfid-20110915_154648_210963_A3931C2B)
Date: Thu, 15 Sep 2011 16:46:38 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] ath6kl: Remove auth type fall back in auto authentication
 mode
References: <1315648597-17999-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1315648597-17999-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/10/2011 12:56 PM, Vasanthakumar Thiagarajan wrote:
> Target already tries with different authentication mechanism
> when authentication type is configured to NL80211_AUTHTYPE_AUTOMATIC.
> Remove this piece of code from driver. Having this code in driver
> even affects auto + WEP authentication in some cases.

Thanks, patches 1-3 applied. Patch 4 dropped per your request. Please
resend it once it's ready.

Kalle
