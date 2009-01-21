Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:53657 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbZAUUc1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 15:32:27 -0500
Received: by nf-out-0910.google.com with SMTP id d3so601531nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jan 2009 12:32:25 -0800 (PST)
Message-ID: <49778657.8020902@gmail.com> (sfid-20090121_213234_252797_44689B2B)
Date: Wed, 21 Jan 2009 20:32:23 +0000
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: Andrey Borzenkov <arvidjaar@mail.ru>,
	orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [Orinoco-devel] [PATCH] orinoco: trivial cleanup in alloc_orinocodev
References: <200901212155.32754.arvidjaar@mail.ru> <1232569292.10843.13.camel@dv>
In-Reply-To: <1232569292.10843.13.camel@dv>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> On Wed, 2009-01-21 at 21:55 +0300, Andrey Borzenkov wrote:
>> Subject: [PATCH] orinoco: trivial cleanup in alloc_orinocodev
>> From: Andrey Borzenkov <arvidjaar@mail.ru>
>>
>> Remove extra space; remove redundant cast
>>
>> Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
> 
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> 
>> -	if (! dev)
>> +	if (!dev)
> 
> There are 41 occurrences of "(! " in drivers/net/wireless, all in
> drivers/net/wireless/orinoco.  Care to fix them all?
> 
> By the way, I made a patch that adds all C sources in
> drivers/net/wireless/orinoco and ran it through checkpatch.pl.  There
> were 226 errors and 174 warnings.  That includes those spaces, trailing
> whitespace, excessively long lines and so on.  It would be great if you
> fix at least some of that.  Actually, long lines are justified in many
> cases, so please don't overdo it.

I've a patch series reorganising the orinoco driver a bit to help with
future changes. It should fix a good proportion of those warnings. I
plan to post it soon - so I'd appreciate it if you held off submitting
further cleanup patches until I get it done (I'll try for the end of
this week).

I should be able to rebase around this one.


Thanks,

Dave.
