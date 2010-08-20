Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57819 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab0HTC5a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Aug 2010 22:57:30 -0400
Received: by gwj17 with SMTP id 17so1039248gwj.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Aug 2010 19:57:30 -0700 (PDT)
Message-ID: <4C6DEF52.6050407@lwfinger.net>
Date: Thu, 19 Aug 2010 21:58:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Jerry-RealtekFAE <jerry-chuang@realtek.com>,
	Gauss Frank <gaussfrank@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-wireless@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	wlanfae <wlanfae@realtek.com>,
	Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Subject: Re: Hi,Linus Torvalds. There's a problem in r8192u driver in Linux
 new kernel.
References: <AANLkTi=1NaRKc8QrQBGwU+c_17D86_Cqu9MopR_rso0H@mail.gmail.com> <AANLkTin3qXSbuWejTGJzz6cO6fycK4HqU4gn4gF1wEdp@mail.gmail.com> <20100812161907.GA25082@suse.de> <76C6BFFEAAA24679B55CBB186C084833@cnfaec24b87a3f> <20100820001531.GA2312@suse.de>
In-Reply-To: <20100820001531.GA2312@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/19/2010 07:15 PM, Greg KH wrote:
> On Mon, Aug 16, 2010 at 05:37:09PM +0800, Jerry-RealtekFAE wrote:
>> Dear Sir/Madam
>>
>> Please find the RTL8192U latest Linux driver in the attachment.
>> Please try it on Kernel 2.6.35-1 again.
> 
> Could you send patches updating the in-kernel version of this driver to
> your latest version?  That would help everyone out in the end.

I have a copy of the driver that Realtek calls the r8712 for the RTL8192 USB
devices. All of the dead code and the unneeded configuration sections have been
removed. It will be submitted to staging as soon as Realtek signs off on the
copyright info. For some reason, it has taken them several weeks and I still
have no answer. This new driver is stable - the connection stays up for days. I
expect that it will replace the current one in staging.

Larry
