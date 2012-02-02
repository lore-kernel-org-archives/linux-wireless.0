Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36006 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab2BBJp5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 04:45:57 -0500
Received: by mail-iy0-f174.google.com with SMTP id b35so2900868iac.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 01:45:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328175087.3626.298.camel@cumari>
References: <1328021048-8944-1-git-send-email-eliad@wizery.com>
	<1328175087.3626.298.camel@cumari>
Date: Thu, 2 Feb 2012 11:45:56 +0200
Message-ID: <CAB3XZEcC92rLVhfKZHitmey69BMhx+VVhPJGkXSDUe6tdL=H-w@mail.gmail.com> (sfid-20120202_104601_615975_06D86FE0)
Subject: Re: [PATCH v2 0/7] wl12xx: add some psm/suspend features
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>, Eyal Shapira <eyal@wizery.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 2, 2012 at 11:31 AM, Luciano Coelho <coelho@ti.com> wrote:
> On Tue, 2012-01-31 at 16:44 +0200, Eliad Peller wrote:
>> Add some psm / suspend features:
>> * Add the ability to force psm (by default, the fw uses dynamic ps)
>> * Use differnet wake up conditions on suspend
>> * Add pattern support to wowlan triggers
>>
>> (depends on the "wl12xx: update fw api" patchset)
>>
>> v2: the rx filters patches were squashed and rewritten (thanks Eyal!)
>>
>> Eyal Shapira (7):
>>   wl12xx: Set different wake up conditions in case of suspend
>>   wl12xx: add suspend_listen_interval debugfs file
>>   wl12xx: add forced_ps mode
>>   wl12xx: add forced_ps debugfs file
>>   wl12xx: add RX data filter ACX commands
>>   wl12xx: add RX data filters management functions
>>   wl12xx: support wowlan wakeup patterns
>>
>
> Eliad, could you split this patchset in two? I can take the first part,
> about forced PS when you send v2.
>
> The WoWLAN part needs to be reworked.  Let's split it out so that it
> doesn't hold the forced PS back.
>
sure.
i'll send it soon.

Eliad.
