Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35828 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab1FBTMf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 15:12:35 -0400
Received: by qyg14 with SMTP id 14so590979qyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jun 2011 12:12:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DD4569C.7080303@candelatech.com>
References: <1305586296-23147-1-git-send-email-greearb@candelatech.com>
 <1305759738.8827.6.camel@jlt3.sipsolutions.net> <4DD4569C.7080303@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 2 Jun 2011 12:12:14 -0700
Message-ID: <BANLkTinozbG2SfOCRd1U__8-Pz9-8HCkPQ@mail.gmail.com> (sfid-20110602_211238_294668_E3CAACEF)
Subject: Re: [PATCH v2] wireless: Support can-scan-one logic.
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 18, 2011 at 4:30 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 05/18/2011 04:02 PM, Johannes Berg wrote:
>>
>> On Mon, 2011-05-16 at 15:51 -0700, greearb@candelatech.com wrote:
>>>
>>> From: Ben Greear<greearb@candelatech.com>
>>>
>>> Enable this by passing a -1 for a scan frequency.
>>
>> I still don't think we should do that, especially not with -1. That's
>> totally non-netlink like inband signalling. I'll also reply to your
>> other mail though since I don't think it makes sense to have this sort
>> of convenience function in the kernel.
>
> It's virtually impossible (as far as I can tell) to carry an
> out-of-tree netlink patch that uses a new netlink message
> and still keep things backwards-compat when someone adds a
> new message to the upstream kernel.  So, the -1 hack works
> well for me.
>
> If it were to go into the kernel proper, then we could
> add a proper flag to the netlink API and start using
> that.
>
> If you just don't like the feature, thats OK...it is a pretty
> specialized feature, and easy enough to carry in my own tree.

Since this shit was merged can you add a respective documentation
extension for the command for nl80211.h?

  Luis
