Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from root-server.richard-scherping.de ([217.160.107.144]:34687 "EHLO
	p15125984.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbYBQRJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2008 12:09:30 -0500
Message-ID: <47B86A44.50004@scherping.de> (sfid-20080217_170934_333733_2B388C2A)
Date: Sun, 17 Feb 2008 18:09:24 +0100
From: Richard Scherping <richard@scherping.de>
MIME-Version: 1.0
To: Fabio Venturi <f.venturi@tdnet.it>
CC: Linux Wireless <linux-wireless@vger.kernel.org>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: Problem compiling ath5k
References: <20080216103846.GC9290@silverstar> <1c252d490802160400gd8a11a6y7e164d9b05f626c8@mail.gmail.com> <20080216172923.GA7439@silverstar> <1c252d490802161607t2bfa8545m1d48b17b272d2534@mail.gmail.com> <20080217101159.GA7234@silverstar>
In-Reply-To: <20080217101159.GA7234@silverstar>
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>> OK,
>>> now the driver compile and load without any problem and
>>> the wlan0 and master0 devices are created.
>>> There are no error in dmesg, but I can't scan for stations,
>>> iwlist wlan0 scan
>>> says there are no active stations.
>>> Do I need extra modules for scanning?
>>> I'm using an Atheros AR2413, is this device supposed to work with
>>> the ath5k module?
> 
> The interface is up and running, but somehow it seems missing
> the beacon packets.
> Best regards,
> Fabio

AR2413 is not yet properly supported in ath5k. The last statement about this is from 15.02.2008, where Nick Kossifidis said:

"Sorry for delaying the relevant patches, i'm working with the 2413
card i got from Mike to make it work and it'll take some time (not as
easy as i thought, i probably miss something)..."

I am waiting for this PHY to get supported, too.

Richard
