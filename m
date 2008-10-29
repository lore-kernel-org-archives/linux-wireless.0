Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:2846 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbYJ2KX3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 06:23:29 -0400
Message-ID: <84144f020810290323i63ce2584v60137ad5cdec5724@mail.gmail.com> (sfid-20081029_112335_757475_D7895F84)
Date: Wed, 29 Oct 2008 12:23:28 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: w35und driver now in mainline/staging
Cc: "kernel list" <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
	lcostantino@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <20081028201342.GA17362@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081028201342.GA17362@elf.ucw.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2008 at 10:13 PM, Pavel Machek <pavel@suse.cz> wrote:
> Just... the w35und driver is now in mainline, and works (well enough
> to ssh over that; but I guess channel is hardcoded).
>
> Testers are needed; its easy, just grab latest 2.6.28-rc2, enable
> staging, enable w35und... and more testing would be helpful.

And should anyone with the affected hardware feel even more
adventurous, I'd love to have someone test my patches before I send
them out. If you're interested, please send me email. The prize for
testing the patches is, of course, a shiny "Tested-by" tag added to
each of them.

                       Pekka
