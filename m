Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39554 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab0JGSbw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 14:31:52 -0400
Received: by iwn9 with SMTP id 9so149179iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Oct 2010 11:31:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1286475342.20974.23.camel@jlt3.sipsolutions.net>
References: <4CAD9368.70608@gmx.com> <AANLkTimTLEShJ3HcBqHaU5U5nFq1UywczC=G7oiHx=as@mail.gmail.com>
 <1286475342.20974.23.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 7 Oct 2010 11:31:31 -0700
Message-ID: <AANLkTimzwhBCVKFnx1vhM4A939_kgixEpw5RLTe8JJb0@mail.gmail.com>
Subject: Re: Vendor specific data within a beacon frame
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bjoern Czybik <wlfw@gmx.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 7, 2010 at 11:15 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-10-07 at 11:11 -0700, Luis R. Rodriguez wrote:
>
> Let me quote what you wrote, but just partially:
>
>> This can be done from userspace. This is from nl80211.h:
>
>>  *      Note: This command has been removed and it is only reserved at this
>>  *      point to avoid re-using existing command number. The functionality this
>>  *      command was planned for has been provided with cleaner design with the
>>  *      option to specify additional IEs in NL80211_CMD_TRIGGER_SCAN,
>>  *      NL80211_CMD_AUTHENTICATE, NL80211_CMD_ASSOCIATE,
>>  *      NL80211_CMD_DEAUTHENTICATE, and NL80211_CMD_DISASSOCIATE.
>
> :P

Yeah just noticed *after* I pasted it and sent it. Does hostapd use
this currently?

  Luis
