Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43810 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab1AHJsd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Jan 2011 04:48:33 -0500
Received: by bwz15 with SMTP id 15so17948989bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 08 Jan 2011 01:48:32 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Aleksandar Milivojevic <alex@milivojevic.org>
Subject: Re: [rt2x00-users] Linksys WUSB600N v1 disconnecting from AP
Date: Sat, 8 Jan 2011 10:47:18 +0100
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Wolfgang Kufner <wolfgang.kufner@gmail.com>,
	Luis Correia <buga@loide.net>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
References: <AANLkTik0uZBVOCnA__UHZLDtw+NNWqK-sEBf1XnyYGYV@mail.gmail.com> <20110107202224.GI21588@tux> <AANLkTintU_vSt5eWoma4_d9tNCxPpOfpGZMq7XXppjpP@mail.gmail.com>
In-Reply-To: <AANLkTintU_vSt5eWoma4_d9tNCxPpOfpGZMq7XXppjpP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201101081047.18475.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag, 8. Januar 2011 schrieb Aleksandar Milivojevic:
> Running 'iw event -t' shows a lot of disassociation due to inactivity.
>  This happens even if there is regular flow of traffic (for example, I
> start ping to my AP and leave it running, or I leave Pandora streaming
> music in the browser).
> 
> Below is example of output of 'iw event -t' (these lines repeat in the
> output at irregularl intervals):
> 
> 1294464037.037450: wlan0 (phy #0): deauth 00:1c:10:ea:2a:cb ->
> 00:1e:52:79:e9:ff reason 4: Disassociated due to inactivity
> 1294464037.037538: wlan0 (phy #0): disconnected (local request)

Aha, so it's not the AP disassociating you but it's your client disconnecting
on its own. Mind to provide the wpa_supplicant log for the same situation when
run with "-ddt"?

Helmut

