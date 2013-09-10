Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44794 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab3IJPbr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 11:31:47 -0400
Message-ID: <522F3B5E.1010100@candelatech.com> (sfid-20130910_173151_506617_A7209AC7)
Date: Tue, 10 Sep 2013 08:31:42 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Eliad Peller <eliad@wizery.com>
CC: Luca Coelho <luca@coelho.fi>, Arik Nemtsov <arik@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 06/12] wlcore: send EAPOL frames with voice priority
References: <1378218848-7853-1-git-send-email-eliad@wizery.com> <1378218848-7853-6-git-send-email-eliad@wizery.com> <1378795636.4799.44.camel@porter.coelho.fi> <CA+XVXfc6RG1BngT_+doiOUhtYAgnG9Q0-oXns-ckJkU7XhE5ag@mail.gmail.com> <1378804510.4799.69.camel@porter.coelho.fi> <CAB3XZEfPQb1FWT3wukBZvSkP9eB1kO=wPpWFxKXBmX5YULAVqw@mail.gmail.com>
In-Reply-To: <CAB3XZEfPQb1FWT3wukBZvSkP9eB1kO=wPpWFxKXBmX5YULAVqw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/10/2013 07:15 AM, Eliad Peller wrote:
> On Tue, Sep 10, 2013 at 12:15 PM, Luca Coelho <luca@coelho.fi> wrote:
>> On Tue, 2013-09-10 at 11:11 +0200, Arik Nemtsov wrote:
>>> On Tue, Sep 10, 2013 at 9:47 AM, Luca Coelho <luca@coelho.fi> wrote:
>>>> On Tue, 2013-09-03 at 17:34 +0300, Eliad Peller wrote:
>>>>> From: Igal Chernobelsky <igalc@ti.com>
>>>>>
>>>>> Send EAPOL frames with voice priority by setting TX_HW_ATTR_EAPOL_FRAME
>>>>> new bit in tx attribute. Sending EAPOL with voice priority fixes
>>>>> re-key timeout during heavy traffic issue.
>>>>>
>>>>> Signed-off-by: Igal Chernobelsky <igalc@ti.com>
>>>>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>>>>> ---
>>>>
>>>> This seems to be the same problem that Ben had and debugged by himself
>>>> [1].  Fixing this in hostapd/wpa_supplicant seems more appropriate?

I just posted hostapd/supplicant patches yesterday that fix it for both
AP mode and for station mode (at least in my configuration using ath9k
and 3.11 kernel).

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

