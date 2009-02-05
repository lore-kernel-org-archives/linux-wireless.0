Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:21455 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbZBEX2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 18:28:08 -0500
Received: by yw-out-2324.google.com with SMTP id 9so240070ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Feb 2009 15:28:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090205154532.M30551@bobcopeland.com>
References: <20090131023147.GE3342@makis> <20090204215706.GA5651@makis>
	 <20090205154532.M30551@bobcopeland.com>
Date: Fri, 6 Feb 2009 01:28:07 +0200
Message-ID: <40f31dec0902051528q3c9f82c2v69c4689ed3b1592f@mail.gmail.com> (sfid-20090206_002813_274997_87B0512F)
Subject: Re: [PATCH 5/5] ath5k: Update reset code
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/2/5 Bob Copeland <me@bobcopeland.com>:
> On Wed, 4 Feb 2009 23:57:06 +0200, Nick Kossifidis wrote
>> * Update reset and sync with HALs
>>  * Clean up eeprom settings and tweaking of initvals and put them on
> separate functions
>>  * Set/Restore 32KHz ref clk operation
>>  * Add some more documentation
>>  TODO: Spur mitigation, tpc, half/quarter rate, compression etc
>>
>>  v2: Address comments from Bob and Felix and fix RSSI threshold bug
>>  introduced on the first version of the patch
>>
>>  Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>
>
> This works much better, except I still get some hard hangs
> occasionally.  Doesn't appear to be bmiss storm this time.  I did it
> with a VT up and didn't get an oops; I guess I'll try a serial console
> or some printks.
>

Did you disable BMISS interrupts on base.c ?





-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
