Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49454 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab1AGJLi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 04:11:38 -0500
Received: by qwa26 with SMTP id 26so17588966qwa.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 01:11:37 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTimekYjYh7uZ3enOQ+zX2_dpA25Zy0aATCDzw521@mail.gmail.com>
References: <AANLkTimekYjYh7uZ3enOQ+zX2_dpA25Zy0aATCDzw521@mail.gmail.com>
Date: Fri, 7 Jan 2011 10:11:37 +0100
Message-ID: <AANLkTimYBb-hqWWtPpQVnVQ2ifemQbAvOBnKSUxM_jsJ@mail.gmail.com>
Subject: Re: Question about ep-n8508
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Damian Minkov <damencho@sip-communicator.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 7, 2011 at 9:06 AM, Damian Minkov
<damencho@sip-communicator.org> wrote:
> Hi,
>
> I recently bought the device EDUP ep-n8508 but I have problems running
> it under Ubuntu 10.10, kernel: 2.6.35-24-generic x86_64.
> I tried with the drivers provided on the CD coming with the device
> (rtl8192CU_linux_v2.0.939.20100726) have no problem compiling and
> installing. But after loading the module no network device appears and
> a lot of "usb write TimeOut!" in the messages.
> Then I tried with latest driver edition from realtek website -
> rtl8192CU_linux_v2.0.1212.20101208. Again with same result.
> Here is all the output: http://pastebin.com/7xhkzYNC.
> I saw there is a similar thread, with similar problems "Question about
> Edimax 7811Un", but as I'm new to the list didn't manage to continue
> that thread.
>
> Seems a problem with amd64 systems. Is there any workaround? Anything
> I can further test to help figuring this out?
>
> Thanks in advance
> damencho

First of all, please do not refer to pastebin-URLs as they have a
limited life-cycle.
A full dmesg and an output of lspci is much more appreciated, so
interested people can look at it.

- Sedat -
