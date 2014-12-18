Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:24485 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaLRR4l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 12:56:41 -0500
Message-ID: <54931556.7020302@broadcom.com> (sfid-20141218_185644_437397_BDA76B8E)
Date: Thu, 18 Dec 2014 18:56:38 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Gautam Kumar Shukla <gautams@broadcom.com>
Subject: Re: [RFC] cfg80211: Add feature flag for 4-way handshake offload
References: <1418907095-10224-1-git-send-email-arend@broadcom.com> <1418909497.6134.5.camel@sipsolutions.net>
In-Reply-To: <1418909497.6134.5.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/18/14 14:31, Johannes Berg wrote:
> On Thu, 2014-12-18 at 13:51 +0100, Arend van Spriel wrote:
>
>> Here the proposed way to deal with new feature flags. Let
>> me know if this is suitable.
>
> I guess that works. I think those functions should be inlines - no point
> in having them with export symbol etc (the structures needed for that
> are *far* bigger than the functions.)

Ok. I should do some self-learning about the things going on behind the 
scene called EXPORT_SYMBOL. Thanks.

Regards,
Arend
