Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60208 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab1CPFJU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 01:09:20 -0400
Received: by wya21 with SMTP id 21so1275513wya.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Mar 2011 22:09:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110315171543.3723e07f@realh.co.uk>
References: <20110224182022.57e32862@toddler>
	<20110224200203.GB17412@elie>
	<20110314164812.4c0cfc29@toddler>
	<AANLkTimSZrGCzBaB9K=WVO7faGNM-+qeKEE2qzjkPnSD@mail.gmail.com>
	<20110315131907.6f06a221@toddler>
	<AANLkTi=Gub1JAO21qtRjxVWrtc6Masp1siF3NHntgcvp@mail.gmail.com>
	<20110315151746.421c04b3@toddler>
	<AANLkTinmD3aJphAcge0xunk4sS4pec20u3PSKTE0Og6=@mail.gmail.com>
	<20110315171543.3723e07f@realh.co.uk>
Date: Wed, 16 Mar 2011 10:39:19 +0530
Message-ID: <AANLkTikTX6eRY2znHLOWLoZo=ryVkN9hpgjE0JYf=UTz@mail.gmail.com>
Subject: Re: Could ath9k and rt2800pci bugs be related?
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Tony Houghton <h@realh.co.uk>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 15, 2011 at 10:45 PM, Tony Houghton <h@realh.co.uk> wrote:
> On Tue, 15 Mar 2011 21:47:14 +0530
> Mohammed Shafi <shafi.wireless@gmail.com> wrote:
>
>> i dont know what to say, may be you can look at
>> vim /drivers/net/wireless/ath/ath9k/pci.c
>> and
>> vim /net/mac80211/pm.c
>> let me also see if i can get the problem reproduced
>
> When I installed wireless-compat it didn't replace all the modules it
> provides, only the ones I'd activated with driver-select ath9k. I didn't
> notice whether mac80211 drivers got replaced too. If I want to alter
> pm.c do I need to add anything to the driver-select line to make sure my
> altered version gets installed?
>
No it won't be necessary. recompilation takes care of it.
