Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f180.google.com ([209.85.161.180]:34418 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab0LQKe7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 05:34:59 -0500
Received: by gxk19 with SMTP id 19so303065gxk.11
        for <linux-wireless@vger.kernel.org>; Fri, 17 Dec 2010 02:34:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <397FC41E-7F1D-4AA8-9D09-6121BB0169E7@mac.com>
References: <57CB308D-7237-46D7-9AF8-7093F52682E8@mac.com> <AANLkTikESPwcaxUSDd3B=Oh7kBD-QpndKRHmu9-roDqs@mail.gmail.com>
 <C77CCCD3-2467-4363-A513-05B68B9F57F6@mac.com> <E680F3C4CE6F415E95DCBDA48F0158FC@MINX0125717>
 <98BC4735-664C-491E-80CE-356BE32FA2ED@mac.com> <AANLkTinejL9LeocQPzjrqrCFYbrF9wqpD9dSyfEVu8us@mail.gmail.com>
 <C4B3622F-ADC4-481E-9340-1819C815184A@mac.com> <AANLkTikvk+AqKRr1VbKv9pSHicy7PAGu8GkdeZuvYwFh@mail.gmail.com>
 <397FC41E-7F1D-4AA8-9D09-6121BB0169E7@mac.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Fri, 17 Dec 2010 12:34:43 +0200
Message-ID: <AANLkTimfNw7Lsp7vnLPt7SaC=SAg0ctMbunRBz4SybhD@mail.gmail.com>
Subject: Re: Problem bringing up wlan0 interface up with mainline wl1271 drivers
To: Elvis Dowson <elvis.dowson@mac.com>
Cc: panduranga <x0125717@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
	Linux Wireless Mailing List <linux-wireless@vger.kernel.org>,
	"Jara, Pedro" <pedrojara@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 17, 2010 at 12:25, Elvis Dowson <elvis.dowson@mac.com> wrote:
> Hi Arik,
>
> On Dec 17, 2010, at 2:12 PM, Arik Nemtsov wrote:
>>
>> The firmware file should be called wl1271-fw.bin and the nvs file
>> should be called wl1271-nvs.bin. Both should reside in /etc/firmware
>> (if you're running a standard linux).
>
> I got the files from this git repo
>
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git
>
> and copied them over to /etc/firmware
>
> /etc/firmware# ls -l
> total 276
> -r--r--r-- 1 root root 271712 Dec 17  2010 wl1271-fw.bin
> -rw-rw-r-- 1 root root    912 Dec 17  2010 wl1271-nvs.bin
>
> But I still get a error saying the the nvs file could not be found:
>
> [   63.852264] wl1271: ERROR could not get nvs file: -2
> [   63.906250] wl1271: loaded
> [   63.909271] wl1271: initialized
>
> Best regards,
>
> Elvis Dowson
>

Sorry Elvis I gave you the wrong path :)
Its /lib/firmware in a regular linux. Its /etc/firmware in android.

Regards,
Arik
