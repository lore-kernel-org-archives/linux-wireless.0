Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:33913 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752405AbbFXPe4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2015 11:34:56 -0400
Received: by ykfy125 with SMTP id y125so25843096ykf.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2015 08:34:55 -0700 (PDT)
Message-ID: <558ACE1C.4020004@lwfinger.net> (sfid-20150624_173459_899622_7E1B99D0)
Date: Wed, 24 Jun 2015 10:34:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Cedric <starke.c@duerr.de>, linux-wireless@vger.kernel.org
Subject: Re: RTL8192cu: not work on linux-2.6.35
References: <54EEFD4D.3060009@byterg.ru> <loom.20150624T100850-505@post.gmane.org>
In-Reply-To: <loom.20150624T100850-505@post.gmane.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/24/2015 03:14 AM, Cedric wrote:
> Do you found any solution for this problem right now. I have totally the
> same Problem and didn't find anything.
>
> This Problem happens with a Netgear WNA1000M and only with some of this
> WLAN-Sticks (I tested more then 1000).
>
>
> Best regards
> Cedric

That driver was not added to the kernel until 2.6.37, thus I would not expect it 
to work with 2.6.35. If you cannot upgrade to a newer kernel, then you should be 
able to get one from Realtek.com, or from 
http://github.com/lwfinger/rtl8192cu.git. Note that the latter driver is 
directly from Realtek, and is provided only as a service. I take no 
responsibility for any bugs or failures to build.

Larry

