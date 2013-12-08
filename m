Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:34095 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab3LHMuk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Dec 2013 07:50:40 -0500
Message-ID: <52A46B10.6030104@candelatech.com> (sfid-20131208_135044_802861_D04D02B5)
Date: Sun, 08 Dec 2013 04:50:24 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>
CC: Mathy <vanhoefm@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Pau Koning <paukoning@gmail.com>,
	linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com
Subject: Re: [PATCH] ath9k_htc: properly set MAC address and BSSID mask
References: <5294E4C5.4050301@cs.kuleuven.be> <52950812.20001@rempel-privat.de> <5295EF41.8040709@cs.kuleuven.be> <CANiGF999jHN3+5QuNVAkVk_hHxZ6LkPxWB3jW9yoJGbfno7M9A@mail.gmail.com> <52972749.70200@gmail.com> <20131206162919.GE13285@tuxdriver.com> <CAFXAJYzO5ifSYbiN7xqV5Sr+3CFrZsaqc2dg0bt-JB0EUxFRdQ@mail.gmail.com> <52A35189.7010804@rempel-privat.de>
In-Reply-To: <52A35189.7010804@rempel-privat.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/07/2013 08:49 AM, Oleksij Rempel wrote:
> I have only one doubt in this patch.
> It will overwrite original MAC. If you wont to restore it, then you need
> to reload module.
>
> If no body against it, i can live it too.

I believe ethtool allows an API to read the eeprom-MAC addr.  Maybe
add support for that API to the ath9k_htc driver so that the original
MAC can be read that way?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

