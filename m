Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41220 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab2BCOOB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 09:14:01 -0500
Received: by qadc10 with SMTP id c10so741297qad.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Feb 2012 06:14:00 -0800 (PST)
Message-ID: <4F2BEB9D.20909@gmail.com> (sfid-20120203_151406_283192_8C40E522)
Date: Fri, 03 Feb 2012 09:13:49 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: mcgrof@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] cleanup modprobe calls
References: <1328237302-13423-1-git-send-email-sidhayn@gmail.com>  <1328237302-13423-2-git-send-email-sidhayn@gmail.com> <1328248669.3626.328.camel@cumari>
In-Reply-To: <1328248669.3626.328.camel@cumari>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/03/12 00:57, Luciano Coelho wrote:
> On Thu, 2012-02-02 at 21:48 -0500, Rick Farina wrote: 
>> There were a lot of needless calls to "modprobe -l <drivername>" and even more confusingly $(MODPROBE).
>> None of this is needed on a modern distro, and it errors on when modprobe -l is removed (such as KMOD in Arch Linux)
>>
>> Signed-of-By: Rick Farina <sidhayn@gmail.com>
>> ---
> I agree with this.  The modprobes are just there in order to list which
> of the relevant modules you have in your system.  There is little value
> in this and, if considered really necessary, there surely must be other
> ways to find out?
>
Although I've never liked all this scrolling, I would have recoded it
rather than removed it if I knew how.  At the present time there is no
way which I know to replicate this functionality. I suppose a find
statement could be added but honestly I just don't see it as necessary,
or any cleaner.

thanks,
Rick Farina
