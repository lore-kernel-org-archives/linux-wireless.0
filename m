Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4303 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab2IQFRq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2012 01:17:46 -0400
Message-ID: <5056B274.5050901@qca.qualcomm.com> (sfid-20120917_071750_585012_0DA981F0)
Date: Mon, 17 Sep 2012 10:47:40 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Wagner <thomas.wagner@hs-rm.de>
CC: Felix Fietkau <nbd@openwrt.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	<ath9k-devel@venema.h4ckr.net>,
	Javier Cardona <javier@cozybit.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath9k: Fix mesh related rx filtering issue for older
 chips
References: <1347634168-20706-1-git-send-email-mohammed@qca.qualcomm.com> <50534AE3.3060107@openwrt.org> <1518263.XlGm7EvTdD@buri>
In-Reply-To: <1518263.XlGm7EvTdD@buri>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tom,

+ linux-wireless

On Saturday 15 September 2012 12:24 AM, Thomas Wagner wrote:
> Hi,
>
>> I'm really not sure about this being tied to sc->nvifs.
>> If it's mesh related, how about just adding a check for the number of mesh interfaces [...]
> No, it is not mesh related!
> Several frames where filtered out.
> I discovered this on trying to set up a mesh.
> But the where filtered frames beyond  the mesh: e.g. a beacon of 802.11b Sitecom Router
>
> @Felix: Pleas forward this mail to:
> linux-wireless@vger.kernel.org
> ath9k-devel@venema.h4ckr.net
>
>

thanks for the clarification.


-- 
thanks,
shafi


