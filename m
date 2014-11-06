Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:12586 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaKFMe3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 07:34:29 -0500
Message-ID: <545B6AD3.8020301@broadcom.com> (sfid-20141106_133432_615022_364528AE)
Date: Thu, 6 Nov 2014 13:34:27 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Ronald Wahl <ronald.wahl@raritan.com>
CC: <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] mac80211: Fix regression that triggers a kernel BUG with
 CCMP
References: <1415267752-4704-1-git-send-email-ronald.wahl@raritan.com> <1415268135.1884.1.camel@sipsolutions.net>
In-Reply-To: <1415268135.1884.1.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06-11-14 11:02, Johannes Berg wrote:
> Oh, regarding Cc stable - don't actually send the mail there if you can
> help it.

What do you mean? Are you saying: It must be tagged, but 'git
send-email' should not actually add the Cc field in the mail header.
What is the story here? Guess I missed a memo ;-)

> johannes

Regards,
Arend
