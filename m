Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58757 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab1JRTzh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 15:55:37 -0400
Received: by ggnb1 with SMTP id b1so949542ggn.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2011 12:55:37 -0700 (PDT)
Message-ID: <4E9DD9C2.4050400@lwfinger.net> (sfid-20111018_215542_056805_04793276)
Date: Tue, 18 Oct 2011 14:55:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Daniel <dalraf@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: rt3090 rt2800
References: <CAMuSxx78MUAm8aM8ptKynbqNk=EkhDGdk_PUEma7G-U0Wqs0hQ@mail.gmail.com>
In-Reply-To: <CAMuSxx78MUAm8aM8ptKynbqNk=EkhDGdk_PUEma7G-U0Wqs0hQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/18/2011 02:39 PM, Daniel wrote:
> Hi.
>
> This
> commit (http://git.kernel.org/?p=linux/kernel/git/next/linux-next-history.git;a=commit;h=fefecc6989b4b24276797270c0e229c07be02ad3)
> you removed the driver rt2860stathat worked with my RT3090 wireless card, the
> current driver rt2800pci does not work with WPA. Will you have some way to help
> me in this direction?

First of all, this question needs to be placed on the wireless mailing list, 
which I have added to this reply.

Although I do not have a card that uses rt2800pci, I am quite certain that it 
works with WPA. Driver rt2800usb, which contains much of the same code, 
certainly does. Try unloading the module and reloading with 'modprobe rt2800pci 
nohwcrypt=1".

We also need a bit more information about your system. What distro? What kernel? 
Do you use NetworkManager? Is the firmware available? What do the logs say? You 
should check the output of dmesg, the system log, and the NM log (if you use it).

Larry

