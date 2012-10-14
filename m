Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:45215 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab2JNNfW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2012 09:35:22 -0400
Message-ID: <507ABE3D.20006@ti.com> (sfid-20121014_153525_909118_BD296572)
Date: Sun, 14 Oct 2012 15:29:33 +0200
From: Victor Goldenshtein <victorg@ti.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <coelho@ti.com>,
	<assaf@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>, <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: Re: [PATCH v3 1/7] nl80211/cfg80211: add radar detection command/event
References: <1344426823-1795-1-git-send-email-victorg@ti.com>  <1344426823-1795-2-git-send-email-victorg@ti.com>  <1347274394.4272.8.camel@jlt4.sipsolutions.net>  <CAK80WHYAH3FdoTDGQh54NdLkYMpv7heGsNjn7venC9fHj65RFw@mail.gmail.com> <1349808418.4683.19.camel@jlt4.sipsolutions.net>
In-Reply-To: <1349808418.4683.19.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/09/2012 08:46 PM, Johannes Berg wrote:
> yeah but if you need to set radar_detect_timeout=0 here, then it looks
> like you're also using the 0 value as a special value to indicate
> "nothing in progress"?
>
We agreed to use "chan->cac_started" flag for that purpose, so there is 
no need to reset "radar_detect_timeout" I will remove it.


-- 
Thanks,
Victor.
