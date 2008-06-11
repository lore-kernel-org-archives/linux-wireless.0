Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:23983 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114AbYFKU0v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 16:26:51 -0400
Received: by yw-out-2324.google.com with SMTP id 9so2026641ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 13:26:34 -0700 (PDT)
Message-ID: <69e28c910806111326j6922905fq1f67201ab4ce298f@mail.gmail.com> (sfid-20080611_222725_658780_E7E0F8CF)
Date: Wed, 11 Jun 2008 22:26:33 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: Open source driver with binary HAL for BCM4313 from Broadcom
Cc: "Michael Buesch" <mb@bu3sch.de>,
	"Tim Gardner" <tim.gardner@canonical.com>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1213213666.19106.12.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48500F14.8070300@canonical.com> <200806112047.00854.mb@bu3sch.de>
	 <1213213666.19106.12.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2008 at 9:47 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Wed, 2008-06-11 at 20:47 +0200, Michael Buesch wrote:
>> On Wednesday 11 June 2008 19:44:52 Tim Gardner wrote:
>> > John,
>> >
>> > Here is the URL to Broadcom's web site advertising their open source
>> > driver with support for the BCM4313.
>> >
>> > http://www.broadcom.com/support/802.11/linux_sta.php
>> >
>> > rtg
>>
>> <quote>
>> Make sure that you download the appropriate tar because the hybrid binary
>> file must be of the appropriate architecture type. The hybrid binary file
>> is agnostic to the specific version of the Linux kernel because it is
>> designed to perform all interactions with the operating system through
>> operating-system-specific files...
>> </quote>
>
> Sure, they are trying to do the MadWifi thing, but it's too late since a
> good free driver exists already, even if it doesn't support that
> particular chip.

I really don't understand why - they should do it the iwlwifi way.

>
> Still, the glue code and the headers are under GPL.  It may be useful
> for reverse engineering efforts.
>
> Perhaps the non-free object files could be used to extract firmware from
> them.  But the license won't allow distribution of that firmware, if I
> understand correctly.
>
> What Broadcom could easily do is to release the firmware under a license
> that would allow free distribution.  This way, the firmware would be on
> installation CDs of the popular distributions, and there would be no
> need to install b43-fwcutter, get the firmware (that's a challenge in
> absence of a wired network), extract the firmware and install it into
> the right directory.  That would make Broadcom cards make out-of-box,
> and ultimately make them more popular.
>
> Instead, Broadcom tries to control the code its users are running.  I
> don't think it's going to work well.  But to be fair to them, at least
> they don't pretend that Linux doesn't exit.

And that's quite an achievement...
Anyway, what are the actual, working download links? The ones on the
site just 404 out for me.

>
> --
> Regards,
> Pavel Roskin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
