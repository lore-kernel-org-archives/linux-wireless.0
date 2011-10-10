Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63761 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab1JJThA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 15:37:00 -0400
Received: by gyg10 with SMTP id 10so5678891gyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 12:37:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318273094.9690.385.camel@cumari>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
	<1318234397-21081-10-git-send-email-eliad@wizery.com>
	<1318273094.9690.385.camel@cumari>
Date: Mon, 10 Oct 2011 21:36:56 +0200
Message-ID: <CAB3XZEc9DcYHmph9wH=+8jQkjBPAiGqHW7P-oVcQJcBHeONNWQ@mail.gmail.com> (sfid-20111010_213705_512931_81FA83F8)
Subject: Re: [PATCH 09/29] wl12xx: make event handling support multirole
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 10, 2011 at 8:58 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Mon, 2011-10-10 at 10:12 +0200, Eliad Peller wrote:
>> Some events don't indicate the role they are intended for.
>> In these cases, iterate through all the relevant vifs,
>> and pass the event to each one of them.
>>
>> This is only a workaround. future fw releases should indicate
>> the relevant role_id for such events.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
> Is this workaround really necessary? Are we going to have a firmware
> that supports multi-role but does *not* pass the role_id for these
> events?
>
i hope not. :)
but in the meantime, we use this workaround to keep compatibility with
the current (single-role) fw.

Eliad.
