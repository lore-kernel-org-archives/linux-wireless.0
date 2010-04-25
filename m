Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59236 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab0DYULI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Apr 2010 16:11:08 -0400
Received: by pwj9 with SMTP id 9so7893083pwj.19
        for <linux-wireless@vger.kernel.org>; Sun, 25 Apr 2010 13:11:08 -0700 (PDT)
Message-ID: <4BD4A1D8.8000203@lwfinger.net>
Date: Sun, 25 Apr 2010 15:11:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Philippe De Muyter <phdm@macqel.be>
CC: Matthew Garrett <mjg@redhat.com>, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org
Subject: Re: b43 'hardware blocked' but only keyboard/led touch button
References: <20100330192629.GA24060@frolo.macqel> <20100330193129.GA31847@srcf.ucam.org> <20100419115329.GA5306@frolo.macqel> <20100419145107.GB8017@srcf.ucam.org> <20100419150050.GA28290@frolo.macqel> <20100419150627.GA10680@srcf.ucam.org> <20100424054210.GA23836@frolo.macqel> <20100424152107.GA13417@srcf.ucam.org> <20100424195630.GA15053@frolo.macqel> <20100424200218.GA16084@srcf.ucam.org> <20100425195058.GA12916@frolo.macqel>
In-Reply-To: <20100425195058.GA12916@frolo.macqel>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/25/2010 02:50 PM, Philippe De Muyter wrote:
> Hello Matthew,
> 
> On Sat, Apr 24, 2010 at 09:02:18PM +0100, Matthew Garrett wrote:
>> On Sat, Apr 24, 2010 at 09:56:30PM +0200, Philippe De Muyter wrote:
>>> On Sat, Apr 24, 2010 at 04:21:07PM +0100, Matthew Garrett wrote:
>>>> Does this laptop also have bluetooth?
>>>
>>> No
>>
>> Hm. I have no idea why hitting the key doesn't change the colour then, 
>> I'm afraid. On the other hand, it sounds like things are working now? 
>> The only thing I can suggest is attempting to clear the CMOS data in the 
>> BIOS menu and see if that changes things.
> 
> Just some more info :
> 
> when I power-on this laptop, the wifi led is red.  The wifi led stays
> red while in the bios and in grub and during the very start of linux boot.
> It becomes blue simultaneously with the displaying of the following message :
> 
> 	ACPI: Core revision 20100121

This makes it clear that b43 is not controlling that LED as the change
to blue on my system only occurs after the interface comes up under the
control of ifup or NetworkManager.

Larry
