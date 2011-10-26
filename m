Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53838 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab1JZIZD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 04:25:03 -0400
Message-ID: <4EA7C3BA.8000108@qca.qualcomm.com> (sfid-20111026_102508_515694_3A0BB198)
Date: Wed, 26 Oct 2011 11:24:26 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 00/31] ath6kl Add multiple vif support
References: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/25/2011 05:03 PM, Vasanthakumar Thiagarajan wrote:
> This patch set adds basic infrastructure for multiple
> virtual interface. As configuring the firmware with more than one
> vif causes random target assert, the number of supported vifs is
> restricted to 1 for now. I would like to thank Vivek Natarajan
> (nataraja@qca.qualcomm.com) for his inital work in this area and
> Arthi Thiruvengadam (athiruve@qca.qualcomm.com) for finding some
> critical bugs.

Thanks, app patches applied. But please do take a look at the lockdep
warning I saw.

Kalle
