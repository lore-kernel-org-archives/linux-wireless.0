Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21550 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754500AbdBNR56 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 12:57:58 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath6kl: Use net_device_stats from struct net_device
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170209112117.23994-1-tklauser@distanz.ch>
References: <20170209112117.23994-1-tklauser@distanz.ch>
To: Tobias Klauser <tklauser@distanz.ch>
CC: <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Message-ID: <5bff5d456de54c548b0b9e8e25f3f825@eusanexr01a.eu.qualcomm.com> (sfid-20170214_185838_487358_698D0047)
Date: Tue, 14 Feb 2017 09:57:54 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tobias Klauser <tklauser@distanz.ch> wrote:
> Instead of using a private copy of struct net_device_stats in struct
> ath6kl_vif, use stats from struct net_device. Also remove the now
> unnecessary .ndo_get_stats function.
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Patch applied to ath-next branch of ath.git, thanks.

1235a3b66cbf ath6kl: Use net_device_stats from struct net_device

-- 
https://patchwork.kernel.org/patch/9564413/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
