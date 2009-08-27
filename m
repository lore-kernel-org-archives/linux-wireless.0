Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:51520 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbZH0CaF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 22:30:05 -0400
Received: by bwz19 with SMTP id 19so622553bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 19:30:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <45e8e6c40908261903r1e495ee6tb69277d99aa83e2b@mail.gmail.com>
References: <4a5cf0b4.F1C7R/E9sD5tpPd2%Larry.Finger@lwfinger.net>
	<4A94B01E.9040309@gmail.com> <4A94C3E9.6070409@lwfinger.net>
	<4A95AA64.20502@gmail.com> <3ace41890908261538s6818b56ax56cca5af18398dbc@mail.gmail.com>
	<4A95C128.5000405@gmail.com> <45e8e6c40908261903r1e495ee6tb69277d99aa83e2b@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 27 Aug 2009 04:29:46 +0200
Message-ID: <69e28c910908261929o64da49b7qefc89bb46a243e33@mail.gmail.com>
Subject: Re: [PATCH] rtl8187: Fix for kernel oops when unloading with LEDs
	enabled
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: Richard Farina <sidhayn@gmail.com>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 27, 2009 at 4:03 AM, Andrey Yurovsky<andrey@cozybit.com> wrote:
> Hi Richard,
>
> On Wed, Aug 26, 2009 at 4:11 PM, Richard Farina<sidhayn@gmail.com> wrote:
>> Again, I'm not trying to point my finger blaming someone, I'm trying to help
>> fix a problem.  I am traveling for the next few days, when I get home to my
>> camera I hope you are all calm enough to help me troubleshoot this bug so we
>> can find a solution instead of accusing each other of accusing each other.
>
> you may want to try kexec in place of having to take photos of the
> kernel panic output.  This will enable you to load a crash-recovery
> kernel, which will be booted automatically once you've successfully
> reproduced the problem.  From there you can use gdb together with
> /proc/vmcore and your kernel image to reconstruct what you'd see in
> dmesg and paste the entire oops.  Please see
> Documentation/kdump/kdump.txt for more details and use
> Documentation/kdump/gdbmacros.txt to give gdb a "dmesg" macro.

Or use the "crash" utility (a wrapper for gdb), which can directly
extract the kernel log from vmcore.

>
>  -Andrey
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
