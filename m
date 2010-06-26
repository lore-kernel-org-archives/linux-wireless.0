Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server.heaven-czfree.net ([78.108.102.201]:43049 "EHLO
	smtp.heaven-czfree.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab0FZMl3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jun 2010 08:41:29 -0400
From: "Jaroslav Fojtik" <jafojtik@seznam.cz>
To: Bruno Randolf <br1@einfach.org>, linux-wireless@vger.kernel.org
Date: Sat, 26 Jun 2010 14:43:47 +0200
MIME-Version: 1.0
Subject: Re: ATH5k - Signal measurement reports wrong values - "calib" did not help
Message-ID: <4C25F603.29925.1365B7A@jafojtik.seznam.cz>
In-reply-to: <201006250947.39223.br1@einfach.org>
References: <4C1E6A13.4259.24AF3C@jafojtik.seznam.cz>, <4C21CDD7.22303.238050@jafojtik.seznam.cz>, <201006250947.39223.br1@einfach.org>
Content-type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Bruno Randolf,

> > Nothing changed after setting "calib" on.

> hey jara!
> 
> setting "calib" is not supposed to change the results, it would just show us 
> debug messages in the kernel log (dmesg). have you tried the patch i sent 
> later? that should fix it...
Thanks for your info. According to logs it looked like noise floor is -94dB
and it is negligible.

I do not know which patch do you mean. If it is integrated into a current
tarball, I could simply download it and try it.
http://www.orbit-lab.org/kernel/compat-wireless-2.6/compat-wireless-2010-06-25.tar.bz2

If it is not, please Email me such patch.

I am currently using compat-wireless-2010-06-22 and it is still affected by
wrong signal measurement.

regards
   Jara




> 
> bruno
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


