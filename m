Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39131 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab2HaPCp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2012 11:02:45 -0400
Message-ID: <5040D1F4.40709@candelatech.com> (sfid-20120831_170250_136740_811CB44A)
Date: Fri, 31 Aug 2012 08:02:12 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Does ath9k support beam forming?
References: <503D14FF.5000309@candelatech.com> <CAD2nsn2JFEAwB0AauFiEYxj=mC7dNjFZn12EQ0q-aOwXjfZj4A@mail.gmail.com> <503E2E66.8010909@candelatech.com> <CAD2nsn3jzWn+pW_3ZQEPtzHRwtZNy_k6=5WtB+F-J-vuMTvyKw@mail.gmail.com>
In-Reply-To: <CAD2nsn3jzWn+pW_3ZQEPtzHRwtZNy_k6=5WtB+F-J-vuMTvyKw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/30/2012 10:28 PM, Mohammed Shafi wrote:
> Hi Ben,
>
> sorry for the delayed reply was bit involved in some other tasks.
>
>>
>>
>> Can you post the latest patch series for this?
>
> there are some commitments which i have to finish it off and i can start
> doing this only out of my free time.  Further it would take some good
> amount of time for testing.
> Unless its not pushed officially validating requires even more effort.
> i hope we can make this work into ath9k.
>
>>
>> And maybe we can make the functionality configurable by debugfs
>> so that we can test it out easily?
>
> yes sure.
>
>>
>> Are there any particular test cases that would help verify the
>> patches?
>
> throughput test cases with variation attenuation and antenna orientation ?
> definitely it should not cause any throughput regressions :)

I'll soon have the ability to script throughput tests v/s various
attenuations (using programmable attenuator that I'm building).

I can do over-the-air tests as well.  Probably 2-4 weeks until I
get everything automated, but when it is, I'll run some baseline
tests and then if you can post patches (RFC is fine if you are
not sure it's ready for upstream) then I can do some tests with
that as well and compare the results...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

