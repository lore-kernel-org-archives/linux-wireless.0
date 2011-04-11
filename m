Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63342 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab1DKDBL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 23:01:11 -0400
Received: by gxk21 with SMTP id 21so2009754gxk.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Apr 2011 20:01:10 -0700 (PDT)
Message-ID: <4DA26EF3.9010605@lwfinger.net>
Date: Sun, 10 Apr 2011 22:01:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: Ben Hutchings <ben@decadent.org.uk>, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org
Subject: Re: Firmware files for Ralink RT28x0
References: <4DA2042A.3010301@gmail.com> <1302469406.5282.341.camel@localhost> <4DA22545.6050209@gmail.com> <4DA2312B.8080303@lwfinger.net> <4DA23594.8090002@gmail.com>
In-Reply-To: <4DA23594.8090002@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/10/2011 05:56 PM, Xose Vazquez Perez wrote:
> On 04/11/2011 12:37 AM, Larry Finger wrote:
>
>> Do you still have the patch from one year ago? I would like to see what you proposed in changes to WHENCE.
>
> Déjà vu
>
> me: http://marc.info/?l=linux-wireless&m=129798073407070&w=2
>
> ivo: http://marc.info/?l=linux-wireless&m=128844402626603&w=2
>
> ralink: http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-March/003381.html
>          http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-March/003382.html

I still don't see any problem with the patch that you supplied. The contribution 
from Ivo and Ralink did not update WHENCE.

I pulled the binary files from the Ralink submission and have entered them into 
my copy of linux-firmware. I need to test that 2860.bin will work with my 
RT3090. Do you have a device that uses rt2800usb?

Larry
