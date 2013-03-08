Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:59270 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab3CHVCd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 16:02:33 -0500
Received: by mail-ob0-f181.google.com with SMTP id ni5so1648976obc.40
        for <linux-wireless@vger.kernel.org>; Fri, 08 Mar 2013 13:02:32 -0800 (PST)
Message-ID: <513A51E6.9090704@lwfinger.net> (sfid-20130308_220236_794435_FB45D69B)
Date: Fri, 08 Mar 2013 15:02:30 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jenya Y <jy.gerstmaier@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: PROBLEM: linux kernel 3.9 rc1 and rtl8187 wireless, unable to
 connect to any available hotspots.
References: <51380336.6030007@live.com> <BLU0-SMTP15357D4D2469B872AE4355CF1E50@phx.gbl> <5138109D.1040605@lwfinger.net> <BLU0-SMTP18556F96AB7DC8FE9D76DA3F1E50@phx.gbl> <513936C8.5060908@lwfinger.net> <513A04BD.3020002@gmail.com> <513A0D9D.8020600@lwfinger.net> <513A1F5F.3080209@gmail.com> <513A2824.30603@lwfinger.net> <513A4154.3040000@gmail.com>
In-Reply-To: <513A4154.3040000@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/08/2013 01:51 PM, Jenya Y wrote:
>
> I just recompiled the kernel with CONFIG_USB_DEBUG flag and here is the output
> of the same commands you provided me with earlier + output of dmesg (though it's
> might be superfluous)

No, it was not. At the end were the lines

[   19.322729] rtl8187: wireless switch is on
[   19.322763] usbcore: registered new interface driver rtl8187
[   19.423269] systemd-udevd[272]: renamed network interface wlan0 to wlp0s29f7u7u3
[   21.321746] IPv6: ADDRCONF(NETDEV_UP): wlp0s29f7u7u3: link is not ready

Why are your udev rules renaming wlan0 to that crazy string?

Your ESSID for the AP of "1.618029" is also strange, but that works OK here.

Note that I added the ML to this reply.

Larry

