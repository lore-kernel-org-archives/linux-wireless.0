Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.224]:21525 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbYEWXQv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 19:16:51 -0400
Received: by wr-out-0506.google.com with SMTP id c48so542149wra.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2008 16:16:50 -0700 (PDT)
Message-ID: <69e28c910805231616m401f5222xfe85ae34ca2fb05d@mail.gmail.com> (sfid-20080524_011654_698815_F167AE86)
Date: Sat, 24 May 2008 01:16:49 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Thomas Kunze" <thommycheck@gmx.de>
Subject: Re: hostap oops
Cc: linux-wireless@vger.kernel.org, j@w1.fi
In-Reply-To: <48374F39.40904@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48374F39.40904@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 24, 2008 at 1:11 AM, Thomas Kunze <thommycheck@gmx.de> wrote:
> Hi,
>
> the hostap driver produces an oops at boot time for me. I use a prism2 compact flash card.
>
> Its seems that this is because the driver receives irqs before it is ready to do so.
>
> I found a patch that solve the problem, but it looks more like a hack.
>
> Any suggestions how to solve this in a better way?
>
> Regards,
> Thomas
> --
>
> <snip>

Hmm... can you make the comments and variables English? You know,
Linus Torvalds is Finnish, yet he still uses English comments and
variable names.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
