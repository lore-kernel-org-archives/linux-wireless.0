Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:18929 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbYKMLtC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 06:49:02 -0500
Received: by yw-out-2324.google.com with SMTP id 9so380000ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2008 03:49:01 -0800 (PST)
Message-ID: <dac45060811130349k3153fcd6i9e6f35f9df3f52ef@mail.gmail.com> (sfid-20081113_124909_880883_E87D5DC5)
Date: Thu, 13 Nov 2008 13:49:01 +0200
From: "Mark Ryden" <markryde@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: Master mode in iw
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
In-Reply-To: <87ej1f6ggq.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <dac45060811130246n41c9983fx2f06f85946b20c1c@mail.gmail.com>
	 <87ej1f6ggq.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
Thanks for you quick response.
I know that I can set master mode with hostapd.

My question is - is there something inherent which
prevents implementing it with "iw"?
When comparing to the old set of tools, which includes
iwconifg,
"iwconfig wlan0 mode Master" works on some interfaces.

Regards,
Mark


On Thu, Nov 13, 2008 at 12:57 PM, Kalle Valo <kalle.valo@nokia.com> wrote:
> Mark Ryden <markryde@gmail.com> writes:
>
>> Hello,
>
> Hello,
>
>> I have a question about the iw: is it possible to
>> set with it an interface to be in master mode ? (as in the case of
>> Access Point)
>>
>> I had git cloned the sources according to the URL from
>> http://linuxwireless.org/en/users/Documentation/iw; and as far
>> as I understand from the code, it is not implemented yet. It will only
>> display when an interface is in master mode (but you cannot set to master mode).
>>
>> I want to verify this point and ask if there is an inhernet reason for
>> not implementing this (setting other modes,
>> like mesh and monitor, is implemented). Or is it simply on the to-do list ?
>
> You have to use hostapd. See earlier mails in this list for more
> information.
>
> --
> Kalle Valo
>
