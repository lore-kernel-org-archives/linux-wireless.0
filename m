Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:35879 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbbGLSdz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2015 14:33:55 -0400
Received: by obdbs4 with SMTP id bs4so217756176obd.3
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2015 11:33:54 -0700 (PDT)
Message-ID: <55A2B30F.4090606@lwfinger.net> (sfid-20150712_203858_437806_28730C11)
Date: Sun, 12 Jul 2015 13:33:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Oliver Kurth <okurth@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Oops with rtl8187
References: <CANfj49UXDJACBjSgdd8RE6=cQ43KMBapOCh7qaQ00jZQZ2bOPQ@mail.gmail.com>
In-Reply-To: <CANfj49UXDJACBjSgdd8RE6=cQ43KMBapOCh7qaQ00jZQZ2bOPQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/12/2015 12:41 PM, Oliver Kurth wrote:
> I have a awus036h (Alfa) wireless usb adapter, which uses the rtl8187
> driver. I am trying to get it to work with a raspberry pi running
> Linux 4.0.7-v7+. It sometimes works for some time, but will always
> eventually crash, bringing the whole network down. I already upgraded
> from 3.18, where I had the same issue. I also tested it by connecting
> it to a Linux vm in VMware Fusion running Ubuntu 15.04 with kernel
> 3.19.0-21 and got the same Oops, so it is not a problem just confined
> to the raspberry or the arm architecture.

What was the architecture of the host machine that was running that Ubuntu VM?

Where are you getting driver 8192cu that is shown in the module list below. If 
you were using the one that has been built into the kernel since 2008, it would 
be named rtl8187. I have used that driver extensively on x86 and x86_64 
architectures, both in x86 hosts and VirtualBox VMs and I have never seen this 
problem.


--snip--

> Oops: 817 [#1] PREEMPT SMP ARM
> Jul 11 06:00:23 raspberrypi kernel: [   41.753311] Modules linked in:
> xt_state iptable_filter ipt_MASQUERADE nf_nat_masquerade_ipv4
> iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
> nf_connt
> rack ip_tables x_tables snd_bcm2835 snd_pcm snd_seq snd_seq_device
> snd_timer snd arc4 rtl8187 eeprom_93cx6 mac80211 cfg80211 rfkill
> 8192cu uio_pdrv_genirq uio


Larry

