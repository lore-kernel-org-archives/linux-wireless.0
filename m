Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:45102 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751762AbYKFAS3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 19:18:29 -0500
Message-ID: <491237C1.4090701@lwfinger.net> (sfid-20081106_011834_212701_B7BF6C88)
Date: Wed, 05 Nov 2008 16:18:09 -0800
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
Subject: Re: [RFC/RFT PATCH v2 2/2] rtl8187: feedback transmitted packets
 using tx close descriptor for 8187B
References: <813803.32421.qm@web23102.mail.ird.yahoo.com>
In-Reply-To: <813803.32421.qm@web23102.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> 
> Before installing compat-wireless, I think the rate started at 36Mb and moves up to 54Mb and get stuck at 54Mb as soon as any traffic is getting through; after installing the patched compat-wireless, the rate changes beteen 1Mb and 9Mb for a bit but get stuck at 1Mb as soon as any substantial traffic is getting through. I can manually switch it with "iwconfig wlan2 rate 36M", for example, but with an auto, "iwconfig wlan2 rate 36M auto", it drops back to 1Mb very soon.
> 
> Baring changes in the rest of the wireless stack (which might come to the same thing), it is probably the changes surrounding status.rate[0].count vs status.retry_count which causes the 1Mb-rate-stuck... 
> 
> Did Larry get the v2 patches to do rate-control working (i.e. the rate actually changing with demand), or not? Larry's reply was "the rate-control mechanism works the way it did before" - I am  not sure about the "it did" bit - same as v1 (rate stuck at 1Mb) or same as the prototype patch for 2.6.27 (rate changing with demand)?  

On my system is started at 1 Mbs and rapidly moved to 54Mbs. It went so quickly
that by the time I started a ping, switched terminals, and issued an ivconfig,
it was already at 54 Mbs.

Larry
