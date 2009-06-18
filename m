Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:42015 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbZFRSbO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 14:31:14 -0400
Received: by qw-out-2122.google.com with SMTP id 5so713662qwd.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 11:31:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890906171052w23882422sa592a0da940ba4a1@mail.gmail.com>
References: <cdc21430906171031o3091a099ubf9c042bb90777d7@mail.gmail.com>
	 <cdc21430906171032gf4f4d0byd0c7e9396206d11f@mail.gmail.com>
	 <43e72e890906171052w23882422sa592a0da940ba4a1@mail.gmail.com>
Date: Thu, 18 Jun 2009 13:25:54 -0500
Message-ID: <cdc21430906181125h6a84a228rce7f5c8886dae78b@mail.gmail.com>
Subject: Re: Newbie: Need help with ath9k module compilation.
	(CONFIG_MODVERSIONS)
From: Rakesh Kumar <gopchandani@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> You can't do that, you would need a backport. We have automatic
> backports available at:
>
> http://wireless.kernel.org/en/users/Download
>
> that's bleeding edge though, from wireless-testing, if you want 2.6.30
> stuff check out:
>
> http://wireless.kernel.org/en/users/Download/stable/
>


Okay, I followed that and am successfully able to load the ath9k
modules now. Now I am facing another issue, so I am doing it on two
machines with same Linux (8.10) and compat-wireless tarball  from the
same day (i.e. same tarball June 17th, 2009) and these two machines
would not be able to scan/detect each other in ad-hoc mode thus not
able to associate and they end up forming two separate IBSS.

I am using follow Atheros chip:

03:02.0 Network controller: Atheros Communications Inc. AR5008
Wireless Network Adapter (rev 01)
	Subsystem: D-Link System Inc Device 3a6d
	Flags: 66MHz, medium devsel, IRQ 18
	Memory at fe7f0000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: <access denied>
	Kernel modules: ath9k



--
Rakesh



I am using iwconfig to put them on same channel, use same essid
