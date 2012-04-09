Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48597 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab2DIQ3t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 12:29:49 -0400
Received: by iagz16 with SMTP id z16so6066127iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Apr 2012 09:29:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F830840.9080502@lwfinger.net>
References: <4F0EEA1B.3040501@wut.de>
	<4F0FA4DD.5020601@lwfinger.net>
	<loom.20120405T091556-756@post.gmane.org>
	<4F7D90AF.2040109@gtri.gatech.edu>
	<4F7E4F2A.1030404@lwfinger.net>
	<CAL9MRr=U+CCzjP-cSOkPJpvw=AQuHX23grj1atfkT9uxLzEM4w@mail.gmail.com>
	<4F7F4A0F.2050300@lwfinger.net>
	<CAL9MRrkeh629QuOTg7fuqPFSsnNiRNW-kTB=gPiqoMipOQfq6Q@mail.gmail.com>
	<4F830840.9080502@lwfinger.net>
Date: Mon, 9 Apr 2012 19:29:49 +0300
Message-ID: <CAL9MRr=DNhWPD69oDpkRmTvTEALcfRDyhyThX6zAbLPUusH-9g@mail.gmail.com> (sfid-20120409_183005_083427_224D9D5E)
Subject: Re: Problem with the rtl8192cu - kernelmodule after ifdown, ifup
From: Nicu Pavel <npavel@mini-box.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	Joshua Roys <Joshua.Roys@gtri.gatech.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Apr 9, 2012 at 7:03 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 04/09/2012 03:40 AM, Nicu Pavel wrote:
>
>> It works if I change:
>> rtl_write_dword(rtlpriv, REG_RCR, ((u32 *) (val))[0]);
>> to:
>> rtl_write_dword(rtlpriv, REG_RCR, mac->rx_conf);
>
>
> That was a pretty stupid mistake! Thanks for working it out.
>
> When I send the patch upstream, may I use your name and E-mail address in a
> "Tested-by:" line?

Yes.

Thanks,
Nicu

>
> Larry
