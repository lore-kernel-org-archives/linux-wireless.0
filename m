Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59655 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945Ab2DIQDR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 12:03:17 -0400
Received: by obbtb18 with SMTP id tb18so5959495obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Apr 2012 09:03:16 -0700 (PDT)
Message-ID: <4F830840.9080502@lwfinger.net> (sfid-20120409_180321_022675_ECB92550)
Date: Mon, 09 Apr 2012 11:03:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Nicu Pavel <npavel@mini-box.com>
CC: linux-wireless@vger.kernel.org,
	Joshua Roys <Joshua.Roys@gtri.gatech.edu>
Subject: Re: Problem with the rtl8192cu - kernelmodule after ifdown, ifup
References: <4F0EEA1B.3040501@wut.de> <4F0FA4DD.5020601@lwfinger.net> <loom.20120405T091556-756@post.gmane.org> <4F7D90AF.2040109@gtri.gatech.edu> <4F7E4F2A.1030404@lwfinger.net> <CAL9MRr=U+CCzjP-cSOkPJpvw=AQuHX23grj1atfkT9uxLzEM4w@mail.gmail.com> <4F7F4A0F.2050300@lwfinger.net> <CAL9MRrkeh629QuOTg7fuqPFSsnNiRNW-kTB=gPiqoMipOQfq6Q@mail.gmail.com>
In-Reply-To: <CAL9MRrkeh629QuOTg7fuqPFSsnNiRNW-kTB=gPiqoMipOQfq6Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/09/2012 03:40 AM, Nicu Pavel wrote:

> It works if I change:
> rtl_write_dword(rtlpriv, REG_RCR, ((u32 *) (val))[0]);
> to:
> rtl_write_dword(rtlpriv, REG_RCR, mac->rx_conf);

That was a pretty stupid mistake! Thanks for working it out.

When I send the patch upstream, may I use your name and E-mail address in a 
"Tested-by:" line?

Larry
