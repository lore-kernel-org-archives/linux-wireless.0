Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15297 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab1KNF21 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 00:28:27 -0500
Date: Mon, 14 Nov 2011 10:57:39 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@adurom.com>
CC: <j@w1.fi>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wpa_supplicant: Set configured auth_algs
Message-ID: <20111114052738.GA9563@vasanth-laptop> (sfid-20111114_062831_047018_30BEF476)
References: <1321023741-32760-1-git-send-email-vthiagar@qca.qualcomm.com>
 <877h35af6x.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <877h35af6x.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 12, 2011 at 11:00:06AM +0200, Kalle Valo wrote:
> Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com> writes:
> 
> > In Ap mode, Authentication algorithm is reset in
> > hostapd_config_defaults_bss() and never be set to the configured
> > one. This would pass the default auth_algs (OPEN|SHARED) to driver
> > and cause authentication isseues.
> 
> Shouldn't you send this to the hostap mailing list?

Oops, forgot it, as the ath6kl patch has a reference to this patch I added
linux-wireless list but missed to add the one meant for hostap. Thanks for
pointing this out.

Vasanth
