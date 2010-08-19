Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sycorax.lbl.gov ([128.3.11.121]:46038 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab0HSQBG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Aug 2010 12:01:06 -0400
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Guy\, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: fix 3945 filter flags
References: <87tynqvtu6.fsf@sycorax.lbl.gov>
	<1279917523.10769.1.camel@wwguy-huron>
	<1280135867.3693.5.camel@jlt3.sipsolutions.net>
	<87mxtd5xlq.fsf@sycorax.lbl.gov>
	<1280212629.19098.0.camel@jlt3.sipsolutions.net>
	<87bp9l6f4k.fsf@sycorax.lbl.gov>
	<1280746705.3923.11.camel@jlt3.sipsolutions.net>
	<878w4pvx5e.fsf@sycorax.lbl.gov>
	<1280766201.24503.0.camel@jlt3.sipsolutions.net>
	<87aap4z70b.fsf@sycorax.lbl.gov>
	<1280817596.3874.0.camel@jlt3.sipsolutions.net>
	<87mxt3n9xh.fsf@sycorax.lbl.gov>
	<1280908365.3768.4.camel@jlt3.sipsolutions.net>
	<87aap28m8v.fsf@sycorax.lbl.gov>
	<1280934185.3768.8.camel@jlt3.sipsolutions.net>
	<8739uu8lg2.fsf@sycorax.lbl.gov>
	<1280934689.17718.3.camel@jlt3.sipsolutions.net>
	<8762zq76p3.fsf@sycorax.lbl.gov>
	<1281964617.3683.23.camel@jlt3.sipsolutions.net>
	<877hjqpl2e.fsf@sycorax.lbl.gov>
	<1282037041.3747.2.camel@jlt3.sipsolutions.net>
Date: Thu, 19 Aug 2010 09:01:00 -0700
In-Reply-To: <1282037041.3747.2.camel@jlt3.sipsolutions.net> (message from
	Johannes Berg on Tue, 17 Aug 2010 11:24:01 +0200)
Message-ID: <87y6c2a8xv.fsf@sycorax.lbl.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> Applying the filter flags directly as done since
>
> commit 3474ad635db371b0d8d0ee40086f15d223d5b6a4
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Thu Apr 29 04:43:05 2010 -0700
>
>     iwlwifi: apply filter flags directly
>
> broke 3945 under some unknown circumstances, as
> reported by Alex.
>
> Since I want to keep the direct application of
> filter flags on iwlagn, duplicate the code into
> both 3945 and agn and remove committing the
> RXON that broke things from the 3945 version.

just to confirm that it works for me. hopefully this will also be
included in the 2.6.36 series. thanks.

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
