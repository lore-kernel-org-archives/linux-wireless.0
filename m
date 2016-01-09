Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34580 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbcAIOOS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jan 2016 09:14:18 -0500
Received: by mail-oi0-f65.google.com with SMTP id x140so1329274oif.1
        for <linux-wireless@vger.kernel.org>; Sat, 09 Jan 2016 06:14:18 -0800 (PST)
Subject: Re: 8192 WiFi Realtek 8192E disconnects after a while and fails to
 reconnect
To: gilbertdion@gmail.com, wlanfae@realtek.com,
	chaoming_li@realsil.com.cn
References: <CAKQFV0H+K46CO62w=9yNRvVaOpwmDj3UKXD0QOmF1XPs54GwnQ@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <569115B5.6@lwfinger.net> (sfid-20160109_151441_649856_6AAA7F58)
Date: Sat, 9 Jan 2016 08:14:13 -0600
MIME-Version: 1.0
In-Reply-To: <CAKQFV0H+K46CO62w=9yNRvVaOpwmDj3UKXD0QOmF1XPs54GwnQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/07/2016 02:30 PM, Gilbert Dion wrote:
> [1] One line summary of the problem
> A few minutes after booting, the Wi-Fi disconnects and it fails to reconnect
> until I restart the machine.
>
> [2] Full description of the problem/report
> I start the machine, a Samsung R580 laptop and the Wi-Fi connects. Then, after 5
> or 10 minutes, while the Wi-Fi still appears to be connected, I can no longer
> load web pages. Then, a few minutes later, the Wi-Fi is disconnected. I tried
> some iconfig commands to try to reconnect it, but it does not work.
> It is crucial to notice that this happens only in 64 bit kernels. I tested 3.13
> to the latest upstream. The machine running a 32 bit kernel stays connected forever.

I have been running my RTL8192E with driver r8192e_pci from a 64-bit kernel 
4.4-rc8 for over 39 hours with no disconnects. Other than the driver logging 
meaningless outputs, all has been fine.

Do you get any real errors logged?

Larry


