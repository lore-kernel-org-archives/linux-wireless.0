Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:41569 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753615AbYKDWbJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 17:31:09 -0500
Message-ID: <4910CD21.6020807@lwfinger.net> (sfid-20081104_233113_492488_4E8993F3)
Date: Tue, 04 Nov 2008 14:30:57 -0800
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: linux-wireless@vger.kernel.org,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
Subject: Re: [RFC/RFT PATCH v2 1/2] rtl8187: implement conf_tx callback to
 configure tx queues
References: <1225806649-10050-1-git-send-email-herton@mandriva.com.br> <1225806649-10050-2-git-send-email-herton@mandriva.com.br>
In-Reply-To: <1225806649-10050-2-git-send-email-herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> Add conf_tx callback and use it to configure tx queues of 8187L/8187B.
> 
> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

This patch is OK. With 1 and 2, the rate-control mechanism works the way it did
before.

Larry

