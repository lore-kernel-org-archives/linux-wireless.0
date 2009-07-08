Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:24678 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZGHKKX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2009 06:10:23 -0400
Received: by fg-out-1718.google.com with SMTP id e12so1064514fga.17
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jul 2009 03:10:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907080948.00065.hs4233@mail.mn-solutions.de>
References: <5135d20a0907070928o19322c3waf41a7b59d4b309e@mail.gmail.com>
	 <200907080948.00065.hs4233@mail.mn-solutions.de>
Date: Wed, 8 Jul 2009 18:10:20 +0800
Message-ID: <5135d20a0907080310h6a67777av27e2a47eb072feb9@mail.gmail.com>
Subject: Re: a question about marvell sd8686's wmm_config_change event
From: fengzeheng <zehengfeng@gmail.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, dcbw@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Holger and dan
    Sorry for my previous wrong message. I go through all the beacon
frames again and found that Ruckus AP update  WMM
IE:wmm_parameter_set_update_counter. But it's strange that other
elements of wmm settings remain unchanged, RUCKUS just update the
update_counter for none of wmm settings updated actually ..........
    thanks

2009/7/8 Holger Schurig <hs4233@mail.mn-solutions.de>:
> On Tuesday 07 July 2009 18:28:47 fengzeheng wrote:
>> hi, dan and all
>>      My wireless card sd8686 reports that wmm_config_change
>> about every 2 seconds though wmm's setting in AP's beacons
>> don't change. seems that driver receive
>> MACREG_INT_CODE_WMM_STATUS_CHANGE event from firmware every 2
>> seconds. And according
>
> Hmm, if the firmware sends you a
> MACREG_INT_CODE_WMM_STATUS_CHANGE but you're sure that the
> beacons don't change, then the firmware seems to be buggy.
>
> Not sure if Marvell got sane and opened up their support for
> no-NDA-holders, but you could try and file a bug there.
>
>
> And we should look into the libertas driver if we always loose a
> packet whenever we get a MACREG :-)
>
> Greetings, Holger
>
> --
> http://www.holgerschurig.de
>



-- 
Best Regards
Feng zeheng
