Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62015 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbaIATKK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 15:10:10 -0400
Received: by mail-ob0-f174.google.com with SMTP id uz6so4100499obc.33
        for <linux-wireless@vger.kernel.org>; Mon, 01 Sep 2014 12:10:09 -0700 (PDT)
Message-ID: <5404C490.9080008@lwfinger.net> (sfid-20140901_211014_793394_5E360D75)
Date: Mon, 01 Sep 2014 14:10:08 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Amitav Mohanty <amitavmohanty01@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Help needed to interpret kernel warning and call trace
References: <CAG0uzYMST12cBwX9v_RAmh+d1muFhQEHSHUhdfMRrTGnPPJq=w@mail.gmail.com>	<5404BDCE.1050007@lwfinger.net> <CAG0uzYM77jdNNbQem_uVN-k5hk2Yh=PaHj=pBXbesocY_9ZHsA@mail.gmail.com>
In-Reply-To: <CAG0uzYM77jdNNbQem_uVN-k5hk2Yh=PaHj=pBXbesocY_9ZHsA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/01/2014 01:55 PM, Amitav Mohanty wrote:
> Hey Larry
> 
> Thank you for the prompt reply. I am not a kernel dev. My intension
> was to seek help and understand how this impacts my system. I looked
> for removing the taint. However, it seems Nvidia driver is the one
> that is tainting the kernel. Since this is the laptop I use for work,
> I don't think I can remove NVidia driver. If I understand correctly,
> using the Nouveau driver instead the proprietary one should remove the
> taint. Is there any other way I can help ?

Yes, nvidia does taint the kernel. If nouveau works, that would remove the taint.

The warning will have exactly zero impact on your system, other than to pollute
your logs.

Larry


