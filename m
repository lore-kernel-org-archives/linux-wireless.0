Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53193 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760802Ab3LIOGb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Dec 2013 09:06:31 -0500
Received: from [192.168.1.100] ([93.218.116.213]) by mail.gmx.com (mrgmx101)
 with ESMTPSA (Nemesis) id 0LlYrb-1VFrFK44db-00bIQo for
 <linux-wireless@vger.kernel.org>; Mon, 09 Dec 2013 15:06:30 +0100
Message-ID: <52A5CE63.1060009@rempel-privat.de> (sfid-20131209_150635_350467_5B141AB6)
Date: Mon, 09 Dec 2013 15:06:27 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Mathy <vanhoefm@gmail.com>, Ben Greear <greearb@candelatech.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Pau Koning <paukoning@gmail.com>,
	linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	vthiagar@qti.qualcomm.com, senthilb@qti.qualcomm.com
Subject: Re: [PATCH] ath9k_htc: properly set MAC address and BSSID mask
References: <5294E4C5.4050301@cs.kuleuven.be> <52950812.20001@rempel-privat.de> <5295EF41.8040709@cs.kuleuven.be> <CANiGF999jHN3+5QuNVAkVk_hHxZ6LkPxWB3jW9yoJGbfno7M9A@mail.gmail.com> <52972749.70200@gmail.com> <20131206162919.GE13285@tuxdriver.com> <CAFXAJYzO5ifSYbiN7xqV5Sr+3CFrZsaqc2dg0bt-JB0EUxFRdQ@mail.gmail.com> <52A35189.7010804@rempel-privat.de> <52A46B10.6030104@candelatech.com> <CAFXAJYyOrd_ybL=roYqdjF_eK81kP1sEBHbjSsXL8y0P_oR38w@mail.gmail.com>
In-Reply-To: <CAFXAJYyOrd_ybL=roYqdjF_eK81kP1sEBHbjSsXL8y0P_oR38w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 08.12.2013 19:09, schrieb Mathy:
> The common->macaddr field is also updated in the ath9k driver
> (function ath9k_calculate_iter_data in main.c).
> 
> I just did a quick test. When using macchanger to assign a random MAC
> address, the original (permanent) MAC address is still retrieved
> properly. So there is no need to reload the module, macchanger can
> simply restore the permanent MAC. I assume the permanent MAC address
> is saved elsewhere?

Right now i have no time to digg deeper in it. I'm ok with this patch.
Thanks a lot for your work!

-- 
Regards,
Oleksij
