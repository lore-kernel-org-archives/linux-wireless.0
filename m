Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:57129 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab3AUKqW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2013 05:46:22 -0500
Message-ID: <50FD1C7C.5050606@neratec.com> (sfid-20130121_114625_942324_72E6D1A6)
Date: Mon, 21 Jan 2013 11:46:20 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv6 0/6] Add DFS master ability
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>  <1358378574.15012.62.camel@jlt4.sipsolutions.net>  <20130117142125.GF19552@pandem0nium> <1358546933.7922.49.camel@jlt4.sipsolutions.net>
In-Reply-To: <1358546933.7922.49.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/18/2013 11:08 PM, Johannes Berg wrote:
> Hi,
> 
>> As stated before: "available until ..." time is not neccessary as far
>> as I know. Also the channel must stay available when AP stops operation,
>> I'll change that.
> 
> Yeah, I checked the documents myself now ... strange, but hey. Radars
> are fixed installations and mostly active continually, so I guess they
> figured it was no big deal.
> 
We were also unsure if this makes sense and contacted regulatory for
clarification. Indeed, with the current document a scenario where "I switched to a
DFS channel and skipped CAC because I passed one half a year ago" is fully
compliant. Practically, when you set up a new AP and do once a CAC for each DFS
channel during installation time, you don't need to do a CAC ever again (as long
as you do not see radars).

Why then bother with CAC at all, one might think. In fact, exploiting given
requirements to such extent is mandatory to make operation on DFS channels usable
(which btw. is not the scope of the patches discussed here).

> [...]
> 
> johannes
> 

