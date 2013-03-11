Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49049 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab3CKTvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 15:51:55 -0400
Message-ID: <513E35CD.3010006@candelatech.com> (sfid-20130311_205159_546534_2D78111B)
Date: Mon, 11 Mar 2013 12:51:41 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k: Allow over-riding reg-domain.
References: <1363020306-924-1-git-send-email-greearb@candelatech.com> <20130311190537.GB32171@tuxdriver.com>
In-Reply-To: <20130311190537.GB32171@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/11/2013 12:05 PM, John W. Linville wrote:
> On Mon, Mar 11, 2013 at 09:45:06AM -0700, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Otherwise, can't get the Sparklan AR9380 NICs to be
>> 5Ghz APs, since they are in world-roaming domain by
>> default.  Add this to /etc/modprobe.d/ath9k.conf:
>>
>> options ath9k override_eeprom_regdomain=0
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>
> Why "=0" to enable it?  Just to make it more confusing?

You are just setting the country code...and country-code 0 seems
to at least open up the US regulatory domain so we use it
by default.

You can use any country code you wish here.

Thanks,
Ben

>
> Do the Atheros folks have an opinion on this?
>
> John
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

