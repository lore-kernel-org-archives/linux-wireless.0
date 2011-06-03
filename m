Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55046 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab1FCHw5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 03:52:57 -0400
Received: by wya21 with SMTP id 21so1189574wya.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jun 2011 00:52:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimnkGyQmEJ2fcowoiv_f+aLm2AQcg@mail.gmail.com>
References: <BANLkTimnkGyQmEJ2fcowoiv_f+aLm2AQcg@mail.gmail.com>
Date: Fri, 3 Jun 2011 13:22:56 +0530
Message-ID: <BANLkTincKD1k1Uq=R8uR-KjExMOErDrOgA@mail.gmail.com> (sfid-20110603_095300_723572_E2F4575E)
Subject: Re: master-2011-06-01 git tree can't recognize my AR9285 chip.
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Matt Chen <machen@novell.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 3, 2011 at 12:13 PM, Matt Chen <machen@novell.com> wrote:
> Hi all,
> I git pull the latest version of wireless-testing tree and built whole
> the kernel and related driver. I found my AR9285 (10ec:002b) can't be
> recognized, and the ath9k is not loaded automatically. I tried the
> kernel 2.6.39, it is working right.

i am compiling the latest tree, i will try out. any debug messages?
sudo modprobe -r ath9k
sudo modprobe -v ath9k debug=0xffffffff(you should have enabled
ATH_DEBUG and ATH9K_DEBUGFS while compiling the kernel).


>
> Some info as below :
> 1) linux:/home/linux/git/wireless-testing # git describe
>    master-2011-06-01
> 2) linux:/home/linux/git/wireless-testing # lspci -nnk
>     ....
>     09:00.0 Network controller [0280]: Atheros Communications Inc.
> AR9285 Wireless Network Adapter
>     (PCI-Express) [168c:002b] (rev 01)
>     ff:00.0 Host bridge [0600]: Intel Corporation Core Processor
> QuickPath Architecture Generic Non-core Registers
>     [8086:2c62] (rev 02)
>     .....
>
>
> --
> Thanks ~
> Matt Chen
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
shafi
