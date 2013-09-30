Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2098 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754834Ab3I3OVC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 10:21:02 -0400
Message-ID: <524988C7.1080903@broadcom.com> (sfid-20130930_162106_280526_3886495E)
Date: Mon, 30 Sep 2013 16:20:55 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Williams" <dcbw@redhat.com>
cc: "Arend van Spriel" <aspriel@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: NetworkManager not connecting anymore
References: <CAJ65rDzRUZcZG5+iz2TeQLW7YS+T5xD+M-BxpJp23N=W4dn1+g@mail.gmail.com>
 <1380549653.6136.4.camel@dcbw.foobar.com>
In-Reply-To: <1380549653.6136.4.camel@dcbw.foobar.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/30/13 16:00, Dan Williams wrote:
> On Sun, 2013-09-29 at 11:11 +0200, Arend van Spriel wrote:
>> With a recent update on my Ubuntu 12.10 laptop, wireless connection is no
>> longer working with NetworkManager. It is working when using wpa_supplicant
>> directly. The nm-applet indicates 'device not ready' for the Wireless
>> Networks. Attached is the syslog upon inserting the wireless driver module,
>> which is brcmsmac. Not sure if the state change below correlates to the
>> nm-applet status.
>>
>> NetworkManager[1121]:<info>  (wlan0): device state change: unmanaged ->
>> unavailable (reason 'managed') [10 20 2]
>
> 'unavailable' could mean a couple things:
>
> 1) supplicant isn't running or can't be contacted via D-Bus

Hi Dan,

Thanks for explaining. 1) seems to be the issue. 'ps -ae | grep wpa' did 
not return anything. I decided to remove and install wpa_supplicant. 
Sometimes the helpdesk approach works ;-)

Regards,
Arend

