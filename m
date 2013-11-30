Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:52017 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3K3SYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 13:24:11 -0500
Received: by mail-we0-f174.google.com with SMTP id q58so10505256wes.33
        for <linux-wireless@vger.kernel.org>; Sat, 30 Nov 2013 10:24:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1980481.3p2Oa8Hyrn@debian64>
References: <CAHdPZaN6GusQbpmNHt=4cHkUKsJTOrGuc0oBF7O8e0oL0neoPQ@mail.gmail.com>
	<1980481.3p2Oa8Hyrn@debian64>
Date: Sat, 30 Nov 2013 13:24:10 -0500
Message-ID: <CAHdPZaPACfFrvXyszwLpT1-iLCrGs_mCh7dR4-_tW=W5V8e1oA@mail.gmail.com> (sfid-20131130_192414_093607_C77C0D5E)
Subject: Re: unable to set iwlwifi master mode
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 30, 2013 at 1:20 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> Hi,
>
> On Saturday 30 November 2013 12:26:11 devendra.aaru wrote:
>> I was trying to use my intel wireless device as an AP.
>>
>> It seem to be that i couldn't able to get it working.
>>
>> in case:
>>
>> 03:00.0 Network controller: Intel Corporation Centrino Wireless-N 1000
>
>
>> What could be the possible mistake?
> Well, The latest version I found for the IWL 1000 was/is v39.31.5.1 Build
> 35138. It looks like this version doesn't "support" AP or P2P mode... and
> it looks like it won't be coming.
>
> You probably want to look for a replacement card. However, if you are using
> a laptop, this might be difficult. Some vendor bios' have a wifi whitelist
> and you have to ask your laptop vendor for the list first or "get creative".
>
> Regards,
>
> Christian

I am using a laptop, so it won't work out for me. Does this version
you are talking
is about the firmware? If so changing it might help out?
