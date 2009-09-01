Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:22980 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201AbZIAVjm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 17:39:42 -0400
Received: by fg-out-1718.google.com with SMTP id 22so214598fge.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 14:39:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A9D9168.2070608@mit.edu>
References: <4A9D9168.2070608@mit.edu>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 1 Sep 2009 23:39:22 +0200
Message-ID: <69e28c910909011439g6eb94e33m3bbfc2e2bbcf47e9@mail.gmail.com>
Subject: Re: 2.6.31 regression: iwlagn power_level no longer works
To: Andy Lutomirski <luto@mit.edu>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 1, 2009 at 11:26 PM, Andy Lutomirski<luto@mit.edu> wrote:
> On 2.6.30.5, I can echo 1 >/sys/class/net/wlan0/device/power_level, and the
> value changes to 1, my wakeup rate goes way down, and my power consumption
> (as measured by powertop) drops noticeably.
>
> On 2.6.31-rc7, I can still echo 1 to that file, but nothing happens, and the
> value I get if I 'cat power_level' remains at 0.
>
> My kernel configs are as identical as 'make oldconfig' knows how to make
> them.
>
> Any ideas?

Power saving has been disabled temporarily in recent versions, as it
caused too many problems. AFAIK either there is either a modparam to
re-enable it or you can re-enable it using iwconfig (it is simply off
by default). There was talk on the mailing list whether to use a
modparam or iwconfig - I don't remember what the outcome was.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
