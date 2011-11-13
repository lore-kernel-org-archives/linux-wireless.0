Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24314 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1KMKtl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Nov 2011 05:49:41 -0500
Message-ID: <4EBFA0B3.7060509@qca.qualcomm.com> (sfid-20111113_114944_884262_A3851434)
Date: Sun, 13 Nov 2011 12:49:23 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: indicate probe-resp offload support
References: <1320772448-20467-1-git-send-email-arik@wizery.com>
In-Reply-To: <1320772448-20467-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/2011 07:14 PM, Arik Nemtsov wrote:
> The ath6kl responds to probe-requests in HW while operating as an AP. It
> supports offloading exclusions to support the WPS, WPS2, P2P and
> 802.11u protocols.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
> I haven't added validation in hostap that check for these flags before
> sending down the probe-resp IEs. This is still useful for tools such as
> iw, that can print out device characteristics.

Thanks, I'll apply this once I merge latest wireless-next to
ath6kl-next. I just can't do it right now.

> I'm not sure 802.11u is actually supported, just seemed so from the
> hostap code sending down the IEs.

Jouni, can you comment on this one?

Kalle
