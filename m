Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:47332 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853Ab2BCF5y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 00:57:54 -0500
Received: by mail-lpp01m010-f49.google.com with SMTP id m7so2064372laa.8
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 21:57:53 -0800 (PST)
Subject: Re: [PATCH 2/2] cleanup modprobe calls
From: Luciano Coelho <coelho@ti.com>
To: Rick Farina <sidhayn@gmail.com>
Cc: mcgrof@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <1328237302-13423-2-git-send-email-sidhayn@gmail.com>
References: <1328237302-13423-1-git-send-email-sidhayn@gmail.com>
	 <1328237302-13423-2-git-send-email-sidhayn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Feb 2012 07:57:49 +0200
Message-ID: <1328248669.3626.328.camel@cumari> (sfid-20120203_065757_366720_2226F140)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-02 at 21:48 -0500, Rick Farina wrote: 
> There were a lot of needless calls to "modprobe -l <drivername>" and even more confusingly $(MODPROBE).
> None of this is needed on a modern distro, and it errors on when modprobe -l is removed (such as KMOD in Arch Linux)
> 
> Signed-of-By: Rick Farina <sidhayn@gmail.com>
> ---

I agree with this.  The modprobes are just there in order to list which
of the relevant modules you have in your system.  There is little value
in this and, if considered really necessary, there surely must be other
ways to find out?

-- 
Cheers,
Luca.

