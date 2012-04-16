Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46514 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab2DPT6x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 15:58:53 -0400
Message-ID: <4F8C79FD.7030701@sipsolutions.net> (sfid-20120416_215857_699762_D41AA0F3)
Date: Mon, 16 Apr 2012 12:58:53 -0700
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3] mac80211: Support on-channel scan option.
References: <1334248689-23018-1-git-send-email-greearb@candelatech.com> (sfid-20120412_183929_638765_C70D881D) <4F8C57CC.4090505@sipsolutions.net> <4F8C59B2.20207@candelatech.com>
In-Reply-To: <4F8C59B2.20207@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/16/2012 10:41 AM, Ben Greear wrote:
>>> + if ((req->channels[0]->flags&
>>> + IEEE80211_CHAN_PASSIVE_SCAN) ||
>>> + !local->scan_req->n_ssids) {
>>
>> That formatting is a bit off it seems. Or is that just my mailer?
>
> Well, it looked OK to me..though when I replied my mailer
> certainly made it look funky. I'll re-run it through checkpatch
> just in case.

It just seemed the & should have a space in front, and it could be on a 
single line with the constant? Anyway, I'm using thunderbird right now 
and don't know what kind of messes it makes.

johannes
