Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:59943 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab2FBODK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jun 2012 10:03:10 -0400
Received: by gglu4 with SMTP id u4so2363303ggl.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jun 2012 07:03:09 -0700 (PDT)
Message-ID: <4FCA1D1B.9070807@lwfinger.net> (sfid-20120602_160346_008475_BD8D08FA)
Date: Sat, 02 Jun 2012 09:03:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jacopo Runchi <jacoporunchi@hotmail.it>
CC: linux-wireless@vger.kernel.org
Subject: Re: I: RTL8187 driver in linux 3.4
References: <!&!AAAAAAAAAAAuAAAAAAAAAH2SKMTPZA1PmAOs8RWvl9YBANlTnCJhprtFudq2LHCBs8EBACQA//8AABAAAACIF7qVX5kVSJrDEtYsG/e+AQAAAAA=@hotmail.it> <DUB107-ds5BA2D5341A3C373209B17A0080@phx.gbl>,<4FC8E733.6030905@lwfinger.net> <DUB107-W18A171E5A851D8D798C403A0080@phx.gbl>,<4FC947BD.50701@lwfinger.net> <DUB107-W21F668D2D3DDFCB2222060A0090@phx.gbl>
In-Reply-To: <DUB107-W21F668D2D3DDFCB2222060A0090@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/02/2012 03:14 AM, Jacopo Runchi wrote:
> So the problem is the same as you reported.
>
> So is there either a bug related to the algorithm who manages the rate, or
> should I change something related to the algorithm?
> I searched for the CONFIG_EXPERT=y setting and for the pid rate algorithm
> setting, but I've not found anything at all.

The parameter is in the kernel configuration file ".config". You need to change 
it with "make menuconfig ARCH=xxxx". Once you set EXPERT to "y", then the PID 
setting will be available in the Network => Wireless settings.

> For it can be ok. Have you planned to do something to correct this at
> driver-kernel level, to work with default "auto" rate?

It is a driver problem, but I do not know how soon it will be fixed. At the 
moment, I have more pressing concerns. Now that I can reproduce it, the fix will 
be easier to find.

Larry

