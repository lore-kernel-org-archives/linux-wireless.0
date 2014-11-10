Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46003 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaKJJMH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 04:12:07 -0500
Received: by mail-wi0-f174.google.com with SMTP id d1so9734484wiv.13
        for <linux-wireless@vger.kernel.org>; Mon, 10 Nov 2014 01:12:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <545FC585.1030709@broadcom.com>
References: <1415551822-20121-1-git-send-email-arik@wizery.com>
 <1415551822-20121-11-git-send-email-arik@wizery.com> <545FC585.1030709@broadcom.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 10 Nov 2014 11:03:55 +0200
Message-ID: <CA+XVXfe7JQCg8RL4exSnMcgiE1jMrTCp_hyTMzOBSBFcZ=GzRQ@mail.gmail.com> (sfid-20141110_101217_392848_F4C02153)
Subject: Re: [PATCH 11/16] cfg80211: introduce TDLS channel switch commands
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 9, 2014 at 9:50 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 11/09/14 17:50, Arik Nemtsov wrote:
>>
>> Introduce commands to initiate and cancel TDLS channel-switching. Once
>> TDLS channel-switching is started, the lower level driver is responsible
>> for continually initiating channel-switch operations and returning to
>> the base (AP) channel to listen for beacons from time to time.
>>
>> Upon cancellation of the channel-switch all communication between the
>> relevant TDLS peers will continue on the base channel.
>>
>> Signed-off-by: Arik Nemtsov<arikx.nemtsov@intel.com>
>> Reviewed-by: Johannes Berg<johannes.berg@intel.com>
>> Signed-off-by: Arik Nemtsov<arik@wizery.com>
>> ---
>>   include/net/cfg80211.h       |   8 ++++
>>   include/net/cfg80211.h.rej   |  15 ++++++
>
>
> Seems something went haywire here or do you really want to add a .rej file
> in this patch?

Doh :)
Thanks for that one.

Arik
