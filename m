Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45776 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab1BOQoP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 11:44:15 -0500
Received: by fxm20 with SMTP id 20so375377fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 08:44:14 -0800 (PST)
Message-ID: <4D5AAC7C.6060509@lwfinger.net>
Date: Tue, 15 Feb 2011 10:40:28 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ben Ruijl <benruyl@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: r8712u: packet loss
References: <AANLkTi=-KJ+OSvDGuxYvDYQZ2ZdS8G8obbvodOXd9zQD@mail.gmail.com> <AANLkTimTecR-W7iGzRWB_DxNVJoovK5SCuWfCmt8SUJo@mail.gmail.com> <AANLkTimx7=kYdWfe8FKL6oMyErE=3=GpXa-YrxkVVBG3@mail.gmail.com>
In-Reply-To: <AANLkTimx7=kYdWfe8FKL6oMyErE=3=GpXa-YrxkVVBG3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/15/2011 06:58 AM, Ben Ruijl wrote:
> I am experiencing packet loss of about 12 percent with the r8712u
> staging driver with my WL-352v2 device. I'm not the only one with this
> problem (https://bbs.archlinux.org/viewtopic.php?id=112120). I haven't
> done a git bisect yet, but I know the problem is in both the 2.6.37
> version and the latest version.

Normally, you should not expect to get much help in this mailing list with a 
driver from staging. I assume that you have seen the warning that is placed in 
the dmesg output when you load a staging driver. You are fortunate in this case 
as I was the one that pushed this driver into staging.

A bisection would not do much good as there have been few changes to the driver 
since it was included.

Please describe your case more completely. List the output of iwconfig. I need 
this info as my device gets a ping packet loss of about 1%.

Larry
