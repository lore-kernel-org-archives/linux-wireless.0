Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63112 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab1GOTbm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 15:31:42 -0400
Received: by wyg8 with SMTP id 8so1016545wyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2011 12:31:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1310723912.4164.20.camel@jlt3.sipsolutions.net>
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
	<1310600747-9583-4-git-send-email-thomas@cozybit.com>
	<1310723912.4164.20.camel@jlt3.sipsolutions.net>
Date: Fri, 15 Jul 2011 12:31:41 -0700
Message-ID: <CAG6hwVN0GgJv327GG7J05c0zLy0OjUjrF+0jn1kVnFWFjKVq9Q@mail.gmail.com> (sfid-20110715_213146_033671_EC40603E)
Subject: Re: [PATCH 3/5] mac80211: Ext. Supported Rates go in mesh beacon tail
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 15, 2011 at 2:58 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2011-07-13 at 16:45 -0700, Thomas Pedersen wrote:
>> Give mesh beacon a tail and maintain Extended Supported Rates IE here.
>> Reorder construction of mesh beacon frame so it looks like:
>>
>> head | tail | mesh IEs | vendor IEs
>>
>> mesh IEs include dynamic elements which must be updated on each beacon.
>
> This is stupid, you're introducing a bug you fix in patch 4/5.
>

True.
> johannes
>
>
