Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:10280 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbZCaI0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 04:26:47 -0400
Received: by ey-out-2122.google.com with SMTP id 4so719224eyf.37
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2009 01:26:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <40f31dec0903310115k247ff208ved52293bda56185a@mail.gmail.com>
References: <20090315202035.GC5246@makis>
	 <200903292204.44260.rossi.f@inwind.it>
	 <40f31dec0903291423s384a98b5l8f86b317aeb5c9a4@mail.gmail.com>
	 <200903301729.28132.rossi.f@inwind.it>
	 <40f31dec0903310115k247ff208ved52293bda56185a@mail.gmail.com>
Date: Tue, 31 Mar 2009 11:26:42 +0300
Message-ID: <40f31dec0903310126teca05d4s3640c05fd4c47d31@mail.gmail.com> (sfid-20090331_102651_551481_13D42DA1)
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
> Anyway since we have such cards
> we just need to put a check there and where pwrL[0] == pwrL[1], we set
> tmp = stepL[0] or if pwrR[0] == pwrR[1], we set tmp = stepR[0]. Try
> this out and see how it goes...
>

(almost there :P) no need to do this, if we get pwrL[0] == pwrL[1]
then we just set min_pwrL = pwrL[0] and skip the loop, same for
min_pwrR.



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
