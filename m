Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:36854 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbcFWOum (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 10:50:42 -0400
Received: by mail-oi0-f48.google.com with SMTP id f189so73559232oig.3
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2016 07:50:41 -0700 (PDT)
Subject: Re: Driver for rtl8188ee
To: jenda <srajerj@seznam.cz>, linux-wireless@vger.kernel.org
References: <576BAAB2.1090401@seznam.cz>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <576BF73F.6080609@lwfinger.net> (sfid-20160623_165048_039011_C70FA9B4)
Date: Thu, 23 Jun 2016 09:50:39 -0500
MIME-Version: 1.0
In-Reply-To: <576BAAB2.1090401@seznam.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/23/2016 04:24 AM, jenda wrote:
> Dear friends
> My notebook for wifi not working. Is configured with Puppy Linux Precise 5.7.1
> and have not driver for rtl8188ee. Pleas help me.
> Thanks Jan Srajer

The driver for the RTL8188EE has been in the kernel since kernel version 3.10, 
which was released approximately 2.5 years ago. If yours is older than that, you 
could use the external driver from http://github.com/lwfinger/rtlwifi_new.git. 
The problem with using that driver is that I'm not sure that a minimal 
distribution like Puppy will have all the tools needed to build external 
modules. That question will need to be asked on a Puppy forum.

Larry


