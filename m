Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53691 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaHDUOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2014 16:14:48 -0400
Message-ID: <53DFE9B5.8040706@candelatech.com> (sfid-20140804_221451_516446_8BE0249C)
Date: Mon, 04 Aug 2014 13:14:45 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Antonio Quartulli <antonio@open-mesh.com>
CC: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH] ath9k: fix aggregation session lockup
References: <1406122854-60239-1-git-send-email-nbd@openwrt.org> <53D6B87D.6080007@candelatech.com> <53D6BC7F.2020002@openwrt.org> <53D7C661.2040107@candelatech.com> <53DF8A36.1040402@open-mesh.com>
In-Reply-To: <53DF8A36.1040402@open-mesh.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/04/2014 06:27 AM, Antonio Quartulli wrote:
> 
> 
> On 29/07/14 18:05, Ben Greear wrote:
>> On 07/28/2014 02:11 PM, Felix Fietkau wrote:
>>> Interesting. Maybe you should ask Antonio for an updated version of the patch that he used to debug this issue. If you give me the output of it while
>>> it's locked up, I might be able to figure out what's going on in your setup.
>> 
>> What is the easiest upstream tree for you to debug?
> 
> Sorry for the late reply but I was pretty "disconnected" in the last days.
> 
> Is the debugging patch still required? If so, I can dig in my buildroot and retrieve it.

I would appreciate it if you could post the patch.  I'd like to
see if I can get the bug fixed once and for all.....

Thanks,
Ben

> 
> Cheers,
> 
> 
> 


- -- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJT3+m0AAoJELbHqkYeJT4OniwH/1mLfg10xq5CPR5eNKCiM2vY
Ww38H/fC5N2K0Uyw84uWTHmJTjqvl4IbW2Xhve4i6yqiQa+NSva/ge5ogK6bLiMH
13AxHysUMnPgu3f9so4wziRuc3izkcs4qgArnXOW03UnVOpAoUbRUVkNPojDzQpM
zkxmQTYTd61XAW6cvOUlvLJsaY6Eapa9ClbIRtj8SuyoIvrvKzKlww96ibnJ7jFR
AXDBSt6n0bPy07DpHuvIs5UypbV2rO6JjQ4WFD85tqScP3+ZEs0KcYk3lv06FXnq
o1SbMSIY24AiLMMhIdIREPadETgft65DGd7wgMarvF8nnqsB7Gnnq0f/YJS32uc=
=daKD
-----END PGP SIGNATURE-----
