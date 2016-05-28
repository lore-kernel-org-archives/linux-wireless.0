Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41420 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbcE1IX6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 May 2016 04:23:58 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: wifi: ath6kl: simplify logical condition
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1463531057-12917-1-git-send-email-xypron.glpk@gmx.de>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
CC: <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	Heinrich Schuchardt <xypron.glpk@gmx.de>
Message-ID: <01f13acfb14a475abc4a9b3c4b5a578b@euamsexm01a.eu.qualcomm.com> (sfid-20160528_102426_175530_07B5EA37)
Date: Sat, 28 May 2016 10:23:50 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Heinrich Schuchardt <xypron.glpk@gmx.de> wrote:
> x <= 7 implies x < 8.
> 
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>

Thanks, 1 patch applied to ath.git:

93b4a09f0f30 ath6kl: simplify logical condition

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9115691/

