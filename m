Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:57454 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab3JKKLk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 06:11:40 -0400
Received: by mail-la0-f48.google.com with SMTP id er20so3103322lab.7
        for <linux-wireless@vger.kernel.org>; Fri, 11 Oct 2013 03:11:39 -0700 (PDT)
Message-ID: <5257CED4.4020406@gmail.com> (sfid-20131011_121143_890846_4A7C3FAA)
Date: Fri, 11 Oct 2013 12:11:32 +0200
From: Thomas Lindroth <thomas.lindroth@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Kernel panic in ieee80211_calculate_rx_timestamp
References: <523B3BEA.9000100@gmail.com>  (sfid-20130919_200122_426878_A0C53351) <1380551237.14467.12.camel@jlt4.sipsolutions.net>
In-Reply-To: <1380551237.14467.12.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/30/2013 04:27 PM, Johannes Berg wrote:
> On Thu, 2013-09-19 at 20:01 +0200, Thomas Lindroth wrote:
>> I recently got a ath9k_htc based dongle and running kismet for a few
>> hours results in a kernel panic (divide error) in
>> ieee80211_calculate_rx_timestamp with kernel 3.11.0.
>>
>> The problem seems to occur when the call to cfg80211_calculate_bitrate
>> returns 0. I've used this patch to temporarily works around the problem.
> 
> Seems fair, but maybe it should print out the rate info so you can see
> what was actually received - most likely this is a driver bug though.
> 
> If you submit a patch that can be applied with signed-off-by etc. I can
> apply it.

Sorry for the late reply. My first post was mostly meant as a bug
report. I don't have the insight needed for a proper fix but that patch
should point a developer in the right direction.

/Thomas Lindroth
