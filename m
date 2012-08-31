Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42529 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab2HaF2e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2012 01:28:34 -0400
Received: by obbuo13 with SMTP id uo13so4823145obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Aug 2012 22:28:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <503E2E66.8010909@candelatech.com>
References: <503D14FF.5000309@candelatech.com>
	<CAD2nsn2JFEAwB0AauFiEYxj=mC7dNjFZn12EQ0q-aOwXjfZj4A@mail.gmail.com>
	<503E2E66.8010909@candelatech.com>
Date: Fri, 31 Aug 2012 10:58:33 +0530
Message-ID: <CAD2nsn3jzWn+pW_3ZQEPtzHRwtZNy_k6=5WtB+F-J-vuMTvyKw@mail.gmail.com> (sfid-20120831_072907_223748_C52F4CB2)
Subject: Re: Does ath9k support beam forming?
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

sorry for the delayed reply was bit involved in some other tasks.

>
>
> Can you post the latest patch series for this?

there are some commitments which i have to finish it off and i can start
doing this only out of my free time.  Further it would take some good
amount of time for testing.
Unless its not pushed officially validating requires even more effort.
i hope we can make this work into ath9k.

>
> And maybe we can make the functionality configurable by debugfs
> so that we can test it out easily?

yes sure.

>
> Are there any particular test cases that would help verify the
> patches?

throughput test cases with variation attenuation and antenna orientation ?
definitely it should not cause any throughput regressions :)

>
>
> Thanks,
> Ben
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
>



-- 
thanks,
shafi
