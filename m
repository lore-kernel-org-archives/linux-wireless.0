Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:23202 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbYITIHd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2008 04:07:33 -0400
Received: by yw-out-2324.google.com with SMTP id 9so127366ywe.1
        for <linux-wireless@vger.kernel.org>; Sat, 20 Sep 2008 01:07:31 -0700 (PDT)
Message-ID: <99175ee40809200107v17dbcfc7hee08d20417c409b4@mail.gmail.com> (sfid-20080920_100743_010382_547A73D3)
Date: Sat, 20 Sep 2008 10:07:30 +0200
From: Chris <dchris@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 11596] New: iwlagn driver in latest linux-2.6 git is not working for intel 4965agn card
Cc: bugme-daemon@bugzilla.kernel.org, linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <20080920005947.de323036.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <bug-11596-10286@http.bugzilla.kernel.org/>
	 <20080920005947.de323036.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm not exactly sure when it was broken. I switched directly from
kernel 2.6.26 (which was working fine) to kernel 2.6 git
(~2.6.27~rc6).

On Sat, Sep 20, 2008 at 9:59 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
>
> On Sat, 20 Sep 2008 00:51:50 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
>
>> http://bugzilla.kernel.org/show_bug.cgi?id=11596
>>
>>            Summary: iwlagn driver in latest linux-2.6 git is not working for
>>                     intel 4965agn card
>>            Product: Drivers
>>            Version: 2.5
>>      KernelVersion: linux-2.6 git
>>           Platform: All
>>         OS/Version: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: normal
>>           Priority: P1
>>          Component: network-wireless
>>         AssignedTo: drivers_network-wireless@kernel-bugs.osdl.org
>>         ReportedBy: dchris@gmail.com
>>
>>
>> Latest working kernel version: Linux-2.6git (~linux-2.6.27-rc6)
>> Earliest failing kernel version: unknown
>> Distribution: Vanilla
>> Hardware Environment: Intel 4965agn card
>> Software Environment:
>> Problem Description: Although my wifi card is detected, and although it is able
>> to scan for access points, it is not able to connect to access points. I tried
>> two access points (one with WPA2 encryption and another without encryption).
>> Authentication is successful but then it seems like it is not able to get an IP
>> from DHCP... DHCP server is working fine and forcing an IP does not work (I'm
>> not able to ping other machines on the wlan).
>>
>> I first noticed this problem on Ubuntu intrepid, which is using 2.6.27-rc6.
>> Then, I decided to compile linux-2.6 git and enable iwlagn debug.
>>
>> I'm joining my logs. I'll be happy to provide more information if necessary.
>>
>> Steps to reproduce: Connect to any access point, authentication is successful
>> but you can't get any IP.
>>
>
> hm, so we broke it in the past few days?
>
