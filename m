Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39686 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab2DRWjl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 18:39:41 -0400
Message-ID: <4F8F42B0.8010306@sipsolutions.net> (sfid-20120419_003944_511780_51F04DB7)
Date: Wed, 18 Apr 2012 15:39:44 -0700
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/6] mac80211: Support getting sta_info stats via ethtool.
References: <1334684807-14026-1-git-send-email-greearb@candelatech.com>   <1334684807-14026-3-git-send-email-greearb@candelatech.com>   (sfid-20120417_194716_243783_5644375D) <1334713070.3725.14.camel@jlt3.sipsolutions.net>  <4F8E3905.70900@candelatech.com> <1334721645.3672.2.camel@jlt3.sipsolutions.net> <4F8EEB6C.1030605@candelatech.com>
In-Reply-To: <4F8EEB6C.1030605@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/18/2012 9:27 AM, Ben Greear wrote:
>> Oh, right, it's adding, I missed that. But is that really useful?
>
> It provides a summary for AP, and precise stats for managed station
> mode (excepting TDLS where it may return sums, it seems).

I just have a feeling that people will rely on it working for managed 
mode, and will forget about TDLS since it's uncommon now ... so I really 
don't think this will work well with people's (even yours!) expectations.

johannes
