Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:48704 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab2LLRIH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 12:08:07 -0500
Message-ID: <50C8B9F6.8010906@qca.qualcomm.com> (sfid-20121212_180812_507376_F98163BD)
Date: Wed, 12 Dec 2012 19:08:06 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless: fix Atheros drivers compilation
References: <1352978222-13866-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1967408.WlU5HIbjCs@lx-vladimir> <87wqwov15r.fsf@purkki.adurom.net> <3215021.3tS1djxBu1@lx-vladimir>
In-Reply-To: <3215021.3tS1djxBu1@lx-vladimir>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 12/12/2012 10:58 AM, Vladimir Kondratiev wrote:

> Subject: [PATCH] wireless: fix Atheros drivers compilation
> 
> Bug introduced in commit:
> wireless: allow Atheros card to not depend on ath.ko
> 
> Change in CONFIG_ option name should be reflected in top level Makefile

You should explain what the bug was (if ath6kl was the only enabled
atheros driver it wasn't included in the compilation).

> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Thanks, this fixed it.

Tested-by: Kalle Valo <kvalo@qca.qualcomm.com>

John, as this bug is in wireless-next and is on it's way to 3.8, we
should get this fix also to 3.8.

Kalle

