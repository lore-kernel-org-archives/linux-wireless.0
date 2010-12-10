Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54992 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab0LJTEg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 14:04:36 -0500
Received: by qwa26 with SMTP id 26so4182315qwa.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Dec 2010 11:04:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D02793E.2050004@lwfinger.net>
References: <1291755360-21570-1-git-send-email-zajec5@gmail.com>
 <AANLkTikp9ErFopLZVmXMjN3tXF2L62SwEEcujKeOBLYC@mail.gmail.com>
 <4CFFA112.7030800@lwfinger.net> <885729A3-72D4-4EFC-AAFE-D2B573E00ED9@ing.unibs.it>
 <1292006874.3531.4.camel@jlt3.sipsolutions.net> <4D02793E.2050004@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 10 Dec 2010 20:04:15 +0100
Message-ID: <AANLkTik2MdDg4g4dFuB6ozZ3Pp3pPORmSAxRAbtznTLP@mail.gmail.com>
Subject: Re: b43 N PHY status report
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Francesco Gringoli <francesco.gringoli@ing.unibs.it>,
	=?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 10, 2010 at 8:02 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 12/10/2010 12:47 PM, Johannes Berg wrote:
>> On Fri, 2010-12-10 at 19:30 +0100, Francesco Gringoli wrote:
>>
>>> [ 1117.516031] unregister_netdevice: waiting for wlan1 to become free. Usage count = 1
>>>
>>> and the device is never release (by who?). I have to reboot.
>>
>> That's a bug in the ipv6 code, upgrade your kernel :-)
>
> I would not have seen that as IPv6 is disabled in my kernels.

Are you serious? Disabling ipv6 with ipv4 exhaustion expected in January?

>
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
