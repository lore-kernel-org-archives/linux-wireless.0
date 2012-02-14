Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54536 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2BNRdV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 12:33:21 -0500
Message-ID: <4F3A9ACB.3010009@candelatech.com> (sfid-20120214_183325_349924_792B96DA)
Date: Tue, 14 Feb 2012 09:32:59 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: Peter Stuge <peter@stuge.se>, ath9k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [ath9k-devel] [PATCH 3/7] ath9k: Merge wiphy and misc debugfs
 files
References: <20280.43962.403799.188541@gargle.gargle.HOWL> <4F3947A1.2060103@candelatech.com> <20281.48485.409968.741657@gargle.gargle.HOWL> <4F39BF5F.3030408@candelatech.com> <20281.52354.478076.479135@gargle.gargle.HOWL> <20120214073855.6843.qmail@stuge.se> <20282.7088.898987.229335@gargle.gargle.HOWL>
In-Reply-To: <20282.7088.898987.229335@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2012 12:30 AM, Sujith Manoharan wrote:
> Peter Stuge wrote:

>> As a compromise, you could suggest a move to a two-level compile time
>> option for debugging. You would enable only what you believe to be

> Having multiple levels of debugging makes things complex. If the general
> consensus is to keep the information, I can rework the patch.

Actually, I think it might be useful to have a second level of debugging.
I hope to soon have time & resources to add some logic to dump lots of register
info and such in human-readable format, (like, when DMA times out).  That is going to be a lot
of strings added to the driver, so the compile size will definitely
increase.  If keeping the size small is important, then this sort of verbose thing
could be hidden behind a second level of debugging...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

