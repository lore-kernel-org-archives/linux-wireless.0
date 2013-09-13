Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:54290 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab3IMRwa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 13:52:30 -0400
Received: by mail-ob0-f169.google.com with SMTP id wp4so1406023obc.0
        for <linux-wireless@vger.kernel.org>; Fri, 13 Sep 2013 10:52:30 -0700 (PDT)
Message-ID: <523350DC.5050905@lwfinger.net> (sfid-20130913_195233_933517_5A3FF24C)
Date: Fri, 13 Sep 2013 12:52:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Timothy Rundle <tgrundlesr@gmail.com>
CC: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: RTL8192CU continually reconnecting
References: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com> <522D054B.5060205@lwfinger.net> <522DD856.7050309@ilande.co.uk> <522DE1BE.6070904@lwfinger.net> <522DE8CA.9010008@ilande.co.uk> <522DFF83.6000605@lwfinger.net> <522E0573.4000804@ilande.co.uk> <522E1B7D.5010107@lwfinger.net> <522E463E.4040701@ilande.co.uk> <522E5416.4010901@lwfinger.net> <522E5D83.9060103@ilande.co.uk> <522E896E.7000607@lwfinger.net> <522EB51A.2080004@ilande.co.uk> <522F3757.8030600@lwfinger.net> <522F7B61.6060208@ilande.co.uk> <5230CDF1.1040905@lwfinger.net> <CALa3VXbxQ1Z2J5weV7rQ16c53D1MQyDL1YGQrV6EkCJYfh=uYA@mail.gmail.com>
In-Reply-To: <CALa3VXbxQ1Z2J5weV7rQ16c53D1MQyDL1YGQrV6EkCJYfh=uYA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/12/2013 05:24 PM, Timothy Rundle wrote:
>
> I finally got some free time to go through all the patches. My results were
> similar to Mark's, but I do not get the watchdog messages, though I am pretty
> sure watchdog is disabled on my PC. I did even try installing openSUSE 12.3, but
> did not have any success.  It didn't even find my wireless network. I manually
> configured the network via network-manager, but still no luck.
>
> Let me know if you need anything else from me.

The watchdog in rtl8192cu has nothing to do with any kernel watchdog timers. 
They are totally separate.

Larry


