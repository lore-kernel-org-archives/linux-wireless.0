Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52021 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab1ITWcB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 18:32:01 -0400
Received: by ywb5 with SMTP id 5so735434ywb.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 15:32:01 -0700 (PDT)
Message-ID: <4E791465.2020000@lwfinger.net> (sfid-20110921_003206_090268_FA755DF8)
Date: Tue, 20 Sep 2011 17:32:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chiefdome <chiefdome@googlemail.com>
CC: linux-wireless@vger.kernel.org, george0505@realtek.com
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
References: <4E77F631.3030202@googlemail.com> <4E77F9FD.1020204@googlemail.com> <4E780309.9010601@lwfinger.net> <4E785DB3.5040109@googlemail.com> <4E7907D3.1020606@googlemail.com>
In-Reply-To: <4E7907D3.1020606@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/20/2011 04:38 PM, Chiefdome wrote:
> I tried at least wireless-next but the adapter isn't showing up.
> Where to get more log files and stuff?
> Isnt this adapter good supported by the rtl8192cu driver or where is the problem?

I have no idea as the only AWUS036 I have is the old one with an RTL8187 chip.

I have been running a wireless-testing 3.1-rc6 kernel with an RTL8188CUS chip 
(USB IDs are 7392:7811) with no problems. George will know more about supporting 
that chip than I do.

I will boot my mainline kernel, but I think it is OK.

If the adapter isn't showing up in wireless-next, you need to check the USB IDs 
using lsusb, and compare them with the USB_DEVICE tables in 
drivers/net/wireless/rtl8192cu/sw.c. The only place that logs will occur is 
dmesg, /var/log/messages, or /var/log/syslog.

Larry

