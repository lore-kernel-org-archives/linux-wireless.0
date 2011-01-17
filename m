Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51142 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab1AQWCy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 17:02:54 -0500
Message-ID: <4D34BC83.2030406@candelatech.com>
Date: Mon, 17 Jan 2011 14:02:43 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Daniel Halperin <dhalperi@cs.washington.edu>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Logs spammed by associate / authenticate / CRDA calls
References: <4D34A421.3070804@lwfinger.net> <AANLkTin_DESckMrOMK41z3oJtXwmHvL026Mi8ayLeKLA@mail.gmail.com>
In-Reply-To: <AANLkTin_DESckMrOMK41z3oJtXwmHvL026Mi8ayLeKLA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/17/2011 12:26 PM, Daniel Halperin wrote:
> On Mon, Jan 17, 2011 at 12:18 PM, Larry Finger
> <Larry.Finger@lwfinger.net>  wrote:
>> The MAC address for the device is 00:1F:1F:C8:8E:CB and that of the AP is
>> C0:3F:0E:BE:2B:45, thus corresponding with the above output.
>>
>> Is scanning this often normal? I suspect it is, but I have not looged the events
>> before.
>>
>> Although both AP and STA support 802.11n, the connection is 802.11g (max 54
>> Mbps) using WPA2-PSK.
>>
>> What triggers the "Disassociated due to inactivity"?
>
> Scanning happens every time you associate/re-associate; disassociation
> due to inactivity happens when your device doesn't send packets to the
> AP for some period of time.  It looks like your AP's (or device's)
> timeout is 100s.

 From what I can tell, this message can also happen if the local
STA thinks it cannot connect to the remote.  For instance, if it
doesn't get a TX callback within 500ms for ath5k/ath9k (and perhaps
others).

Thanks,
Ben

>
> Dan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

