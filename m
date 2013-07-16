Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fep13.mx.upcmail.net ([62.179.121.33]:38426 "EHLO
	fep13.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab3GPHex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 03:34:53 -0400
Message-ID: <51E4F790.6090308@odi.ch> (sfid-20130716_093515_557850_B16A0639)
Date: Tue, 16 Jul 2013 09:34:40 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [BUG] 3.10 regression: hang on suspend
References: <51E4501D.3010001@odi.ch> <20130716065626.GA1587@redhat.com>
In-Reply-To: <20130716065626.GA1587@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 16.07.2013 08:56, Stanislaw Gruszka wrote:
> Apparently this commit changed suspend procedure on mac80211, but it's
> not obvious for me why it hangs :-(

Hangs are hard :-) It just sits there with a black screen and a white 
cursor in the top left corner...

> What is your user space configuration (are you using NM or other
> software or maybe just wpa_supplicant)? Are you using wowlan?
> If you do add no_console_suspend boot parameter does it print some
> diagnostic messages during suspend before the hang ?

Yes, I am using NM under KDE, with KDE triggered suspend. No wowlan 
AFAIK. The last thing I see in the log is something from NetworkManager 
that sees the device switching off. I can try again tonight and give you 
the exact message.

I will also try without NM and bare wpa_supplicant and a plain suspend 
through sysfs.

Any debug options you want me to enable? Netconsole won't work however...

Ortwin
