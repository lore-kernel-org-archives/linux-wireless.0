Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34163 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab1I0IDH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 04:03:07 -0400
Received: by gyg10 with SMTP id 10so4912391gyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2011 01:03:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317109617.4082.0.camel@jlt3.sipsolutions.net>
References: <1317119624-2974-1-git-send-email-stanv@altlinux.org>
	<1317109617.4082.0.camel@jlt3.sipsolutions.net>
Date: Tue, 27 Sep 2011 12:03:05 +0400
Message-ID: <CAN8FffqH=x+qWnz=YJzatbW-b3aOgoivazH6Nb5SpsGt4Q6hGg@mail.gmail.com> (sfid-20110927_100314_092254_05E09448)
Subject: Re: [PATCH 1/1] rfkill: add module option to become inactive.
From: "Andrew V. Stepanov" <stanv@altlinux.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: davem@davemloft.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 27, 2011 at 11:46 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-09-27 at 14:33 +0400, Andrew V. Stepanov wrote:
>> From: Andriy Stepanov <stanv@altlinux.ru>
>>
>> Use as:
>> modprobe rfkill unblocked=1
>> or
>> /etc/modprobe.d/options
>> options rfkill unblocked=1
>
> Apart from the obvious style problems in this patch (tons of extra
> braces) I'm not convinced this is a good idea.
>
> What problem does it solve? Why can that problem not be solved
> differently with existing mechanisms (e.g. urfkilld configured to do
> nothing)?
>
> johannes
>

1. I can remove extra braces.

2. urfkilld  can't be used to ignore Hard blocked buttons.
