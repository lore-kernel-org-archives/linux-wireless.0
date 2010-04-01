Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:45619 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab0DAH1J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 03:27:09 -0400
Received: by fxm27 with SMTP id 27so223821fxm.28
        for <linux-wireless@vger.kernel.org>; Thu, 01 Apr 2010 00:27:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1270056176.2446.3494.camel@rchatre-DESK>
References: <m2j4c251d3f1003302243z67d9c5f0v93cec04fb3543ceb@mail.gmail.com>
	<1270056176.2446.3494.camel@rchatre-DESK>
From: Jeremi Thebeau <jeremi.thebeau@googlemail.com>
Date: Thu, 1 Apr 2010 09:26:48 +0200
Message-ID: <g2s4c251d3f1004010026rbb8030e0pc820fa75c96df52e@mail.gmail.com>
Subject: Re: Intel Corporation PRO/Wireless 4965 AG or AGN randomly shuts off
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Reinette,

I haven't played around much with ucode, linux modules, dirver and
applying patches. Do you have a suggestion for a good primer. I will
try to make sense of that ridiculously long bug when i get a chance.
Assuming I am able to install and patch, if the device drops off
again, are there any specific logs I should keep an eye on to help
test this patch?

Jeremi

On Wed, Mar 31, 2010 at 7:22 PM, reinette chatre
<reinette.chatre@intel.com> wrote:
> Hi Jeremi,
>
> On Tue, 2010-03-30 at 22:43 -0700, Jeremi Thebeau wrote:
>
>> jeremi@linux64:~$ uname -a
>> Linux linux64 2.6.31-20-generic #58-Ubuntu SMP Fri Mar 12 04:38:19 UTC
>> 2010 x86_64 GNU/Linux
>>
>> with Ubuntu Karmic 64 bit.
>
> Is it possible to give the latest driver code a try to ensure we are
> dealing with the latest features? compat-wireless may be an easy way for
> you to do this.
>
> We have seen some devices that essentially get disconnected from the
> platform, which seems to be happening here. We prepared a patch for this
> a while ago, but nobody with this issue has yet been able to test it.
> Perhaps you could? Please try
> http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2037#c112 ...
> hopefully it will still be straight forward to apply.
>
> Reinette
>
>
>
