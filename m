Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:61187 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750952AbZALPFZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 10:05:25 -0500
Message-ID: <496B5C2D.4030607@lwfinger.net> (sfid-20090112_160528_923319_7802EE29)
Date: Mon, 12 Jan 2009 09:05:17 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jayant Sane <jayant_sane@hotmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Newbie question on 2.6.28-rc8-wl
References: <BLU129-W39120C9D5D733AC53C210180DB0@phx.gbl> <496A27FA.5030508@lwfinger.net> <BLU129-W353904E1AB1EEE7AC28C7D80D80@phx.gbl>
In-Reply-To: <BLU129-W353904E1AB1EEE7AC28C7D80D80@phx.gbl>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jayant Sane wrote:
> 
> Thank you.
> 
> Again pardon my ignorance here..
> 
> It seems that I can either get 2.6.28-wl or 2.6.28-rc8 per your suggestions below but not 2.6.28-rc8-wl
> 
> And I know it is possible to have the kernel version reported as 2.6.28-rc8-wl.  How can I get that?

The -wl part comes from the presence of a file named
"localversion-wireless" in the wireless-testing directory. This file
has one line with the contents of that line being "-wl" (without the
quotation marks, or course).

If you are compiling this particular kernel to get some wireless
driver, then 2.6.28-wl is likely to be better than 2.6.28-rc8-wl.
Please elaborate your reason for being told to get the -rc8 variant.

Larry

