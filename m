Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:37705 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbYKDXLn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 18:11:43 -0500
Message-ID: <4910D6A3.2030704@openwrt.org> (sfid-20081105_001147_176509_265F58E4)
Date: Wed, 05 Nov 2008 00:11:31 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
Subject: Re: [RFC/RFT PATCH v2 1/2] rtl8187: implement conf_tx callback to
 configure tx queues
References: <1225806649-10050-1-git-send-email-herton@mandriva.com.br> <1225806649-10050-2-git-send-email-herton@mandriva.com.br> <4910CD21.6020807@lwfinger.net>
In-Reply-To: <4910CD21.6020807@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> Herton Ronaldo Krzesinski wrote:
>> Add conf_tx callback and use it to configure tx queues of 8187L/8187B.
>> 
>> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> 
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
> 
> This patch is OK. With 1 and 2, the rate-control mechanism works the way it did
> before.
Has anybody tested this thing with the minstrel rate control yet?
At some point I would like to make minstrel the default RC,
since it has shown much better performance on drivers like b43 or ath5k.

- Felix
