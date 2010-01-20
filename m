Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:45390 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab0ATDPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 22:15:42 -0500
Received: by fxm25 with SMTP id 25so152653fxm.21
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2010 19:15:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1263956213.2316.4.camel@fwdell4550>
References: <1263951622.3259.26.camel@fwdell4550> <69e28c911001191800t23bab697q6354b07656f78a29@mail.gmail.com>
	<1263956213.2316.4.camel@fwdell4550>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 20 Jan 2010 04:15:21 +0100
Message-ID: <69e28c911001191915n54ebb06q9d12e6822db61fb9@mail.gmail.com>
Subject: Re: b43 driver hang with bcm4318
To: Eric Volker <evolker@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/20 Eric Volker <evolker@gmail.com>:
> On Wed, 2010-01-20 at 03:00 +0100, Gábor Stefanik wrote:
>> Please load b43 with verbose debug messages enabled (use the "verbose"
>> module parameter - check modinfo for the exact value for full debug
>> output), and post the resulting logs.
> Loaded b43 with verbose=3 to get debug output. The driver hung much more
> quickly with debug output enabled. After about 30 seconds of pinging the
> AP became unresponsive, though it was still beaconing. Should I post the
> logs to the list, or is there somewhere else they should go?
>
> Thanks,
>
> Eric Volker
>

Please post the logs here for analysis. That's specifically the reason
I asked you to load b43 with debugging enabled.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
