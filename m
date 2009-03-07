Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:36546 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbZCGVyo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2009 16:54:44 -0500
Received: by yw-out-2324.google.com with SMTP id 5so630488ywh.1
        for <linux-wireless@vger.kernel.org>; Sat, 07 Mar 2009 13:54:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49B2B9E4.9090006@lwfinger.net>
References: <960a51b60903070942q31d4d5e2n835f2c642cd19d70@mail.gmail.com>
	 <49B2B9E4.9090006@lwfinger.net>
Date: Sat, 7 Mar 2009 16:54:41 -0500
Message-ID: <960a51b60903071354ked42068w829e233cf3cc7d94@mail.gmail.com> (sfid-20090307_225447_042505_161866DD)
Subject: Re: Intermittent wlan operation ( b43-phy0 ERROR: PHY transmission
	error).
From: Tom Cada <thomas.cada@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 7, 2009 at 1:16 PM, Larry Finger <Larry.Finger@lwfinger.net=
> wrote:
> Tom Cada wrote:
>> I went so far as to download the broadcom-wl-4.150.10.5.3 drivers
>> thinking that a more recent version would have addressed the problem=
=2E
>> However, I found out I couldn't install them with the error:
>>
>> =C2=A0$ ../../b43-fwcutter-011/b43-fwcutter -w /lib/firmware wl_apst=
a_mimo.o
>> Sorry, the input file is either wrong or not supported by b43-fwcutt=
er.
>> This file has an unknown MD5sum b84bc801b9b8f39069c252f533655af8.
>
> The driver is b43. What fwcutter gets is firmware. AFAIK, the firmwar=
e for your
> device that you are using is the same as that of driver 4.150.10.5.3.=
 There is a
> difference in the firmware for LP and N PHY devices, but as they are =
not yet
> supported, it doesn't matter.
>
> We are aware of those errors, but don't know why they occur, or how t=
o fix them.
> Sorry.
>
> Larry
>
>

Oh poo!

I guess I will have to fire up ndiswrapper.

Thanks for the reply.  Place me on the list if you would like me to
test any changes.

Tom.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
