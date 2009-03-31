Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:36284 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZCaIQl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 04:16:41 -0400
Received: by ewy9 with SMTP id 9so2422460ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2009 01:16:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <40f31dec0903310115k247ff208ved52293bda56185a@mail.gmail.com>
References: <20090315202035.GC5246@makis>
	 <200903292204.44260.rossi.f@inwind.it>
	 <40f31dec0903291423s384a98b5l8f86b317aeb5c9a4@mail.gmail.com>
	 <200903301729.28132.rossi.f@inwind.it>
	 <40f31dec0903310115k247ff208ved52293bda56185a@mail.gmail.com>
Date: Tue, 31 Mar 2009 11:16:38 +0300
Message-ID: <40f31dec0903310116u1363ec8bpe466d4c62f5d4b25@mail.gmail.com> (sfid-20090331_101646_863960_A1047FC8)
Subject: Re: [PATCH 3/3] ath5k: Add tx power calibration support
From: Nick Kossifidis <mickflemm@gmail.com>
To: Fabio Rossi <rossi.f@inwind.it>
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/3/31 Nick Kossifidis <mickflemm@gmail.com>:
>
> It's weird that your EEPROM contains a value twice, both pwrL[0] and
> pwrL[1] are 4 so interpolation always returns 4 and tmp is always > 1
> so you have an endless loop.

(still sleeping) it doesn't return 4 (that's the pwr lvl) but the same
pcdac step :P



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
