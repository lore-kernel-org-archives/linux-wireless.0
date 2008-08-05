Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:57055 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757718AbYHEP0m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 11:26:42 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2645223rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Aug 2008 08:26:41 -0700 (PDT)
Message-ID: <1ba2fa240808050820j1aa0ae7cj11f2758caa5ba4df@mail.gmail.com> (sfid-20080805_172645_224949_17EFCB0D)
Date: Tue, 5 Aug 2008 18:20:27 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwl5000 oopses (was: iwl5000 oopses with Linus's tree)
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1217938927.3603.40.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217937364.3603.37.camel@johannes.berg>
	 <1217938927.3603.40.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 5, 2008 at 3:22 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>> This is kernel 2.6.27-rc1-00504-g2b12a4c-dirty
>
> Same happens with a newer kernel, I merged together wireless-testing and
> linux-2.6 (because powerpc won't build in -rc1) and get this:
>
> [  126.826663] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27kds
> [  126.826947] iwlagn: Copyright(c) 2003-2008 Intel Corporation
> [  126.828369] iwlagn: Detected Intel Wireless WiFi Link 5350AGN REV=0x24
> [  126.848680] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
> [  127.014564] firmware: requesting iwlwifi-5000-1.ucode
> [  127.170640] iwlagn: Error wrong command queue 43 command id 0x6B
> [  127.170832] ------------[ cut here ]------------
> [  127.170884] kernel BUG at drivers/net/wireless/iwlwifi/iwl-tx.c:1163!
> [  127.170941] Oops: Exception in kernel mode, sig: 5 [#1]


Something is messing up the queues.
Will check
Thanks
Tomas
