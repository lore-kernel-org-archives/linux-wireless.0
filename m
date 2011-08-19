Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3542 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755485Ab1HSO3m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Aug 2011 10:29:42 -0400
Message-ID: <4E4E7345.5020701@broadcom.com> (sfid-20110819_163000_009995_2EB2D45D)
Date: Fri, 19 Aug 2011 16:29:25 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "Pedram Navid" <pedram.navid@gmail.com>
cc: "Henry Ptasinski" <henryp@broadcom.com>,
	"ali@internetdog.org" <ali@internetdog.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcmsmac: fifo 0: descriptor error
References: <6264DDFA6754194CAB6452BFF5202C330F5F2115@SXGM-401.fg.rbc.com>
 <CAPoLzpe0OYq677NooOY5F7PyvbNobOXXCuSnoaF7ZVc0cJkjAw@mail.gmail.com>
 <20110811021554.GA24567@internetdog.org>
 <CAPoLzpeQF_xO_4eT2CKfp9cXKWUopssHjCkXd3_b0e8EAn8e_w@mail.gmail.com>
 <20110811222624.GJ8119@broadcom.com>
 <CAPoLzpeuPy9T7Q471pBz7A-RLuZykjo-apadm-nGjVdQhM9-7Q@mail.gmail.com>
In-Reply-To: <CAPoLzpeuPy9T7Q471pBz7A-RLuZykjo-apadm-nGjVdQhM9-7Q@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Pedram,

Bugzilla seems to be AWOL today so lets continue the discussion by email.

I noticed this issue is still pending. It is weird that the problem 
persists between cold reboots (which points to a hardware error) but is 
also dependent on the kernel version in use (which points to a software 
error).

Would you happen to have additional cards to try ?

Can you email a log file containing the 'fifo 0: descriptor error' bug ?

Do you think that temperature has an effect on the bug occurring, does 
it make a difference if you let your machine cool down between reboots ?

I identified an issue today that gives the same error message, but that 
issue only occurs on 64 bit platforms, and you report that you also see 
it on 32 bit platforms.

Can you run a memory test on your system, e.g. one that tests the memory 
during an overnight test ? Reason is that the error message occurs 
because the DMA engine read invalid data from memory.

Thanks, Roland.

On 08/12/2011 02:33 AM, Pedram Navid wrote:
> Hi Henry,
>
> I have filed this as bug 40972 along with the answers to your
> questions: https://bugzilla.kernel.org/show_bug.cgi?id=40972
>
> In short, yes, the error does appear immediately after a full
> power-off shutdown as soon as I bring the interface up after loading
> the module. Not always, but more often than not.
>
> I am running 32-bit but have used 64bit prior. I reinstalled my system
> thinking that it was a problem with 64-bit libraries. The full lsmod
> is on the bug report.
>
> I am currently running fine again. I will keep my laptop on throughout
> the day in the hopes that it goes down. Let me know if you need
> anything else.
>
> Thanks so much
> Pedram

