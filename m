Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:45377 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbZLaOih convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Dec 2009 09:38:37 -0500
Received: by fxm25 with SMTP id 25so6714542fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 31 Dec 2009 06:38:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1262037590.16627.99.camel@localhost.localdomain>
References: <4B38A298.7070103@googlemail.com>
	 <1262037590.16627.99.camel@localhost.localdomain>
Date: Thu, 31 Dec 2009 14:38:35 +0000
Message-ID: <3ace41890912310638x4387f73bvc7ba5e00d096ead7@mail.gmail.com>
Subject: Re: staging: No option to select rtl8192su in linux-2.6.33-rc2
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Chris Mayo <aklhfex@googlemail.com>,
	linux-wireless@vger.kernel.org, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 28, 2009 at 9:59 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Chris,
>
>> If you have no other wireless drivers selected then RealTek RTL8192SU
>> does not show up in menuconfig for staging.
>>
>> rtl8192su needs the "select WIRELESS_EXT" fix for "wext: refactor"?
>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3d23e349d807177eaf519d444677cee86b1a04cf
>>
>> as done for some in:
>> http://git.kernel.org/?p=linux/kernel/git/gregkh/staging-2.6.git;a=commitdiff;h=125b181aec7a67c71234284ecf6d9c729d05deda
>>
>>
>> Also:
>> rtl8192u, wlan-ng, wlags49_h2(?)
>
> if staging drivers break, then please create a patch and mail it do
> Greg. Don't bother linux-wireless with it since nobody here actually
> cares about the staging drivers.

"nobody cares" is not entirely true - AFAIK, code in the staging area
is unreliable/unsuitable/"poor" code which serves the sole purpose of
being there for scavenging and references for re-write (because there
is no equivalent functionality, even alleged, in mainline); so people
looking at the staging code for ideas or references is welcomed. It is
just that there is no hints of any support or vague guarantee that any
of it works for any fitness of purpose. i.e. patches which fix
problems, or migrate functionality out of the staging area to
main-line, are welcomed, but questions and request for help on
understanding or making any of it work, are not.

>
> Regards
>
> Marcel
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
