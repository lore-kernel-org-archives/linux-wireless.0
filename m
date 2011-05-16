Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37555 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab1EPDjk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 May 2011 23:39:40 -0400
Received: by iyb14 with SMTP id 14so3416584iyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 15 May 2011 20:39:39 -0700 (PDT)
Message-ID: <4DD09C78.2010304@lwfinger.net> (sfid-20110516_053948_785003_9178F673)
Date: Sun, 15 May 2011 22:39:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Rob Browning <rlb@defaultvalue.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: Slow receive with rtl8192cu (usb ew-7811Un)
References: <87pqnl5i81.fsf@raven.defaultvalue.org>	<4DD074E3.3090502@lwfinger.net> <87vcxbe5xz.fsf@trouble.defaultvalue.org>
In-Reply-To: <87vcxbe5xz.fsf@trouble.defaultvalue.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/15/2011 09:26 PM, Rob Browning wrote:
> Larry Finger<Larry.Finger@lwfinger.net>  writes:
>
>> Could you please try the attached patch to see if it improves your
>> throughput?
>
> Certainly.  Can I patch one of the linux-wireless trees, or should I get
> the source and build the whole kernel?
>
>> In addition, please file a Bugzilla report for this problem at
>> http:bugzilla.kernel.org.

You could patch either the linux-2.6 kernel (2.6.39-rc7), the wireless-testing 
git tree, or get the source from your distro. You will have to build the entire 
kernel as I do not have the necessary make files to build the driver as an out 
of kernel module.

Larry
