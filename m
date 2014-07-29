Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:34037 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbaG2OZx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2014 10:25:53 -0400
Received: by mail-oi0-f49.google.com with SMTP id u20so7368574oif.22
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2014 07:25:52 -0700 (PDT)
Message-ID: <53D7AEF5.5040907@lwfinger.net> (sfid-20140729_162556_949070_5E49BFF1)
Date: Tue, 29 Jul 2014 09:25:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Borislav Boev <borislavboev@hotmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Poor wifi performance on Intel 7260 Dual-Band AC Wifi card
References: <BAY178-W38CA42DFDD4031D453FB48CFF80@phx.gbl>
In-Reply-To: <BAY178-W38CA42DFDD4031D453FB48CFF80@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/29/2014 02:28 AM, Borislav Boev wrote:
> Hello, I am reporting this bug, though it is well known for years. In general I've experienced poor wifi performance with all Intel cards, starting from 3945abg, 4965agn and now Intel 7260 Dual-Band AC.
> The old cards were on a ThinkPad T61 system, 7260 is on a brand new ThinkPad Edge E540.
> 
> So here's the problem:
> Wireless conection is slow, there's a unusual ping while browsing web pages (tried with all browsers - no luck), and sometimes drop-outs in connection.
> There's a partial fix by disabling Wireless "N" mode, but this is irrational, because it limits the network to only 54mbits speed.
> 
> Details about the system:
> Hardware:
> ThinkPad E540
> CPU: Intel core i5-4200m (Haswell)
> Wireless adapter: Intel 7260 Dual-Band AC
> 
> Software:
> PCLinuxOS 2014.07
> Kernel: 3.15.5 (though it was the same with old kernels)
> Kernel module: iwlwifi 

You should try the experimental firmware file from
https://git.kernel.org/cgit/linux/kernel/git/egrumbach/linux-firmware.git/plain/iwlwifi-7260-9.ucode?h=Core6.

I am currently testing it and getting throughput of 60 Mbps on the 2.4 GHz band,
and 90 Mbps at 5 GHz.

Larry

