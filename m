Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:42448 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbbAPOab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 09:30:31 -0500
Received: by mail-wi0-f171.google.com with SMTP id ho1so4509516wib.4
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 06:30:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1421356430.1962.15.camel@sipsolutions.net>
References: <CACsJT9OOBcYNhNG6=+Q2EE4VHEvJ8_rJ3fr6gb9_3P4KpPPX3g@mail.gmail.com>
 <f46d043c061e8dd5c9050cb5990c@google.com> <CACsJT9M9LcHEuEa2mgAB2taYATZq4j_NeLq78w+=-VBvOw1NGw@mail.gmail.com>
 <54B82598.9060403@erley.org> <1421356430.1962.15.camel@sipsolutions.net>
From: Mike Purvis <mpurvis@clearpathrobotics.com>
Date: Fri, 16 Jan 2015 09:30:09 -0500
Message-ID: <CACsJT9PsyW1EJmkNJSaQe7Y7S_2qkupn3cr0QRS8DSwRvTU86g@mail.gmail.com> (sfid-20150116_153035_367906_2D6EBBDC)
Subject: Re: Delivery Status Notification (Failure)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Pat Erley <pat-lkml@erley.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Okay, captured the configuration from the working machine:

https://gist.github.com/mikepurvis/d8977be6865cebd18ff3

Looks like 8087:07da is the centrino bluetooth component, but it's not
at all obvious!

Thanks very much for the assistance.

Mike

On 15 January 2015 at 16:13, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2015-01-15 at 14:39 -0600, Pat Erley wrote:
>
>> I'd guess that the 6235 module has WLAN on the pci-e connector portion,
>> and Bluetooth on the USB portion.
>
> Yes, that's the case for all Intel wifi modules that have BT.
>
> johannes
>
