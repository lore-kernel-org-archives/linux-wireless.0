Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45414 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab1E3XI0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 19:08:26 -0400
Received: by iyb14 with SMTP id 14so3255094iyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 May 2011 16:08:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <umt4d3izhp45.fsf@gmail.com>
References: <345324.53571.qm@web161601.mail.bf1.yahoo.com> <umt4d3izhp45.fsf@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 31 May 2011 09:08:06 +1000
Message-ID: <BANLkTinHupLVp4JDGHZN72k4TqR7apPU7Q@mail.gmail.com> (sfid-20110531_010834_661139_9213EA41)
Subject: Re: AP mode - usb wlan interface: Sagem XG-76NA 802.11bg
To: mafeuser@gmail.com
Cc: Walter Goldens <goldenstranger@yahoo.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 31, 2011 at 07:09,  <mafeuser@gmail.com> wrote:
> Hallo Walter.
>
> Thank YOu for the answer.
>
> I didn't know about compat-wireless package, thus that's why I upgraded
> by ubuntu 10.04 to ubuntu 11.04, then gotten newest kernel 2.6.39 week
> ago.
>
> then I did:
> $ iw list
> Wiphy phy0
> ....
> ....
>        Supported interface modes:
>                 * IBSS
>                 * managed
>                 * AP           !!!! YES, YES
>                 * AP/VLAN
>                 * monitor
>                 * mesh point
>
> BUT:(((((:
>
> $ sudo iwconfig wlan0 mode master
> Error for wireless request "Set Mode" (8B06) :
>    SET failed on device wlan0 ; Invalid argument.
>
> I was a little bit disappointed, that's why I decided to ask You.
>
> What am I doing wrong?

You can't set master mode with iwconfig. Access point mode needs a
program to run in userspace to handle some of the heavy lifting. You
need to read this FAQ entry:

http://wireless.kernel.org/en/users/Documentation/FAQ#Q:_iwconfig_wlan0_mode_master_does_not_work

Then look up hostapd

http://wireless.kernel.org/en/users/Documentation/hostapd

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
