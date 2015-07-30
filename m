Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32890 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbbG3Fky (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 01:40:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: <zajec5@gmail.com>, <linux-wireless@vger.kernel.org>,
	<b43-dev@lists.infradead.org>
Subject: Re: [PATCH] b43: fix extpa_gain check for 2GHz
References: <1438205790-17629-1-git-send-email-hauke@hauke-m.de>
Date: Thu, 30 Jul 2015 08:40:36 +0300
In-Reply-To: <1438205790-17629-1-git-send-email-hauke@hauke-m.de> (Hauke
	Mehrtens's message of "Wed, 29 Jul 2015 23:36:30 +0200")
Message-ID: <8738065hkb.fsf@kamboji.qca.qualcomm.com> (sfid-20150730_074057_039478_D7E30CCE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hauke Mehrtens <hauke@hauke-m.de> writes:

> On the 2GHz and and on the 5GHZ band only the extpa_gain setting from
> the 5GHz band was checked. this patch makes it check the property from
> the correct band.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Is this a regression? If yes, please add a Fixes line.

Should this go to 4.2?

-- 
Kalle Valo
