Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58315 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbZHTOrd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 10:47:33 -0400
Date: Thu, 20 Aug 2009 10:46:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: LP-PHY: Implement spec updates and remove
	resolved FIXMEs
Message-ID: <20090820144649.GA2657@tuxdriver.com>
References: <4A8AE255.9030102@gmail.com> <69e28c910908191514w3073d382x927062038f2bb128@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <69e28c910908191514w3073d382x927062038f2bb128@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 20, 2009 at 12:14:13AM +0200, Gábor Stefanik wrote:
> Seeing that this is still not in wireless-testing - this patch should
> be applied, the previously mentioned regressions were false alerts
> (Larry tested without this patch and with v478 firmware, which worked;
> while Mark applied this patch and used v410 firmware, which didn't
> work - when Mark upgraded to v478 firmware, his card too came to
> life.) So, please apply.

You posted the above slightly more than 7 hours after the "false alert"
message below.

> Date: Wed, 19 Aug 2009 16:57:37 +0200
> From: Gábor Stefanik <netrolller.3d@gmail.com>
> To: John Linville <linville@tuxdriver.com>, Michael Buesch <mb@bu3sch.de>,
>         Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Mark Huijgen <mark@huijgen.tk>,
>         Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
>         linux-wireless <linux-wireless@vger.kernel.org>
> Subject: Re: [PATCH] b43: LP-PHY: Implement spec updates and remove resolved
>         FIXMEs
> 
> False alert, sorry. Feel free to apply. The "regression" apparently
> resulted from the use of an incorrect firmware image - when Mark
> switched to the same firmware as Larry, his card started working
> again.

It seems that you think I am a little gnome that sustains itself on email and
git, but I assure you that I am not.  I have other things to do.

I am truly glad that you have taken-up the cause of LP-PHY support
for b43.  Nevertheless, being heckled by you does nothing to make me
want to merge your patches any faster.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
