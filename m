Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4387 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757586AbXLMW22 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 17:28:28 -0500
Date: Thu, 13 Dec 2007 17:13:23 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Bjorge Dijkstra <bjd@jooz.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: status wireless extensions API for new drivers
Message-ID: <20071213221323.GF3083@tuxdriver.com> (sfid-20071213_222831_745078_DE3262EA)
References: <4761A108.2080005@jooz.net> <20071213213118.GE3083@tuxdriver.com> <4761AD18.8000004@jooz.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4761AD18.8000004@jooz.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 13, 2007 at 11:07:20PM +0100, Bjorge Dijkstra wrote:
> John W. Linville wrote:
>>
>> WEXT is fine for new drivers.  At this time cfg80211 does not offer
>> a suitable replacement.
>
> Ok, thanks. I'll stick to WEXT for now then..

BTW, how is your patchset looking?  If you want it to be in 2.6.25
then you need to post it soon.

FWIW, as long as you have just enough WEXT support to get it to work
with open networks I think that would be enough to get a patch merged.
Having experimented a bit earlier with your patchset, I suspect you
can probably support WEP and maybe more by now...

So, when will we see your patches?

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
