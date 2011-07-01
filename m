Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:1454 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab1GAUNn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 16:13:43 -0400
Message-ID: <4E0E2A75.3040009@gnu.org> (sfid-20110701_221347_462858_BC20A44B)
Date: Fri, 01 Jul 2011 16:13:41 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: ant2ne <ant2ne@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: carl9170 and debian squeeze
References: <AANLkTimL=JSK6jcF4d97Nc-vLZdeRLj8o=MbpCas-H7z@mail.gmail.com> <28292.82403.qm@web56807.mail.re3.yahoo.com> <AANLkTi=GgTWU1QmoqxM_rA8jUX7814PvZqsEGvcnc6ps@mail.gmail.com> <AANLkTi=OcXfoo8gFQ+qTYDgL4XaKXiGZpUSSiL8yT_ho@mail.gmail.com> <loom.20110701T212014-423@post.gmane.org>
In-Reply-To: <loom.20110701T212014-423@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/01/2011 03:25 PM, ant2ne wrote:
> Was there ever a solution for this?
>
> I continue to get the "Unknown symbol in module" error.

Please be specific and quote the error messages as is.  Also please give 
the exact command so that others have a chance to tell you if you are 
doing something wrong.  If you are using insmod, please try modprobe, as 
only modprobe can load other modules that provide the required symbols.

Please see the kernel log using the dmesg command.  It should have more 
detailed information about the unresolved symbols.

If you just installed compat-wireless, please reboot, as it would unload 
the old wireless modules and load the new ones.  If you cannot reboot, 
you'll need to run "make unload" in the compat-wireless directory.

 > I've got squeeze with
> 2.6.32-5 kernel
> and I've tried a variety of compat-wireless versions including the latest 3.0
> stable.

Do they all have the same problem?

-- 
Regards,
Pavel Roskin
