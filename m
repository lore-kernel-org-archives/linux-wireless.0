Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:49608 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaGJO7w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 10:59:52 -0400
Received: by mail-ob0-f178.google.com with SMTP id nu7so2186856obb.23
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 07:59:49 -0700 (PDT)
Message-ID: <53BEAA6E.8000304@lwfinger.net> (sfid-20140710_165955_735766_D7C71AC7)
Date: Thu, 10 Jul 2014 09:59:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Talbut <jt@dpets.co.uk>, linux-wireless@vger.kernel.org
Subject: Re: rtl8192se static driver in 3.14 kernel not working
References: <53BE5E49.6040603@dpets.co.uk>
In-Reply-To: <53BE5E49.6040603@dpets.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/10/2014 04:35 AM, John Talbut wrote:
> It seems that we have a different problem with this driver from others I
> mentioned in a recent thread.
>
> I have compiled a kernel from the 3.14.7 from linux-source-3.14 from Debian for
> use on a Samsung N120 netbook.
>
> Included in the .config are:
>
> CONFIG_WLAN=y
> CONFIG_RTL_CARDS=y
> CONFIG_RTL8192SE=y
>
> There are no LKMs or initramfs.
>
> The wireless does not work at all.  dmesg shows the pci device but there is no
> sign of the wireless driver.
>
> With a 2.6 kernel set up similarly the wireless works.

Please post the entire .config.

Larry


