Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:48198 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751365AbdINU36 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 16:29:58 -0400
Subject: Re: ROAM/CONNECT event with PORT_AUTHORIZED
To: Denis Kenzior <denkenz@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Jouni Malinen <j@w1.fi>
References: <1505378361.31630.2.camel@sipsolutions.net>
 <e4a3ab99-f49a-0849-56d7-71ce19b1f323@broadcom.com>
 <1505389462.31630.6.camel@sipsolutions.net>
 <e418234f-00a0-dd44-7352-d279f49f83e5@gmail.com>
 <1505416658.31630.15.camel@sipsolutions.net>
 <9219316a-5556-6acf-30de-e9aa65a05706@gmail.com>
 <6d0ad07b-ca89-19a1-d3c2-ad94915b942a@candelatech.com>
 <c2a820c4-f169-6a4d-13f3-3df323f1556a@gmail.com>
 <5436d106-0b4a-9158-58bf-ff84b231cd19@candelatech.com>
 <c97ecdb4-fe7a-e79a-d73e-32166beb1e11@gmail.com>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <8a26a838-adde-08f1-5f64-c98e1d947675@candelatech.com> (sfid-20170914_223001_524003_20704249)
Date: Thu, 14 Sep 2017 13:29:57 -0700
MIME-Version: 1.0
In-Reply-To: <c97ecdb4-fe7a-e79a-d73e-32166beb1e11@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2017 01:26 PM, Denis Kenzior wrote:
> Hi Ben,
>>
>> How do you re-confirm them?  There are definitely cases where SSID/Security is the same but each
>> AP has its own DHCP server and roaming between them will require getting a new DHCP address (on
>> the same (NAT'd) subnet and with same gateway, likely as not).
>>
>
> Using DHCPREQUEST to verify obtained parameters, or the DHCPv6 equivalent Confirm message.  This obviously requires some integration between the dhcp daemon and
> the supplicant.

Do you want to allow the just-now-roamed station to use its old IP address(es) while you are
confirming?

If not, how is this different from just re-doing DHCP like normal?

And if so, you will in some cases be allowing duplicate IP addresses on
a network?

Thanks,
Ben

>
> Regards,
> -Denis
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
