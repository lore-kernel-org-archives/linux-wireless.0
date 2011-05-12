Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49772 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758052Ab1ELRA5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 13:00:57 -0400
Date: Thu, 12 May 2011 12:59:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Mohammed Shafi <mshajakhan@atheros.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Mohammed Shajakhan <Mohammed.Shajakhan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@atheros.com>
Subject: Re: [RFC/RFT 0/9] ath9k: Add Antenna diversity support for AR9485
Message-ID: <20110512165907.GM2490@tuxdriver.com> (sfid-20110512_190102_714633_73E77699)
References: <1304000579-5784-1-git-send-email-mshajakhan@atheros.com>
 <BANLkTi=8Vc5MGjK=K3=hkFLy=kiFy1osCg@mail.gmail.com>
 <BANLkTinFYwvWSWreUd66DGdsdyo2uU53Hw@mail.gmail.com>
 <4DBA4417.40604@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4DBA4417.40604@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 29, 2011 at 10:22:39AM +0530, Mohammed Shafi wrote:
> On Thursday 28 April 2011 11:42 PM, Luis R. Rodriguez wrote:
> >On Thu, Apr 28, 2011 at 11:12 AM, Luis R. Rodriguez
> ><lrodriguez@atheros.com>  wrote:
> >>On Thu, Apr 28, 2011 at 7:22 AM, Mohammed Shafi Shajakhan
> >><mshajakhan@atheros.com>  wrote:
> >>>From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
> >>>
> >>>*These are purely RFC/RFT patches, none of them are tested.
> >>>  once tested we will send it as patches.
> >>>*This patch set adds Antenna diversity support for AR9485, previously
> >>>  antenna diversity is only supported in AR9285
> >>>*The basic antenna diversity algorithm remains the same
> >>>*slight change in the diversity field in eeprom
> >>>*introduction of main/alt gain table and lna1_lna2 delta fields
> >>>*initially set LNA1 for main antenna
> >>>*introduction of diversity group
> >>>*based on diversity group, fast diversity bias parmaters and
> >>>lna1_lna2_delta varies
> >>>*implement an API to take the decision of swapping main/ALT LNA's
> >>>for AR9485
> >>>*configure fast diversity bias based on diversity group
> >>Apart from my one comment:
> >>
> >>Reviewed-by: Luis R. Rodriguez<lrodriguez@atheros.com>
> >Oh yeah and great job on your patch split!
> thanks!
> >   Luis

This series was posted RFC -- do you want it merged now?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
