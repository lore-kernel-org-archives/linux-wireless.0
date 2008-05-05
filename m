Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3369 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbYEER64 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 13:58:56 -0400
Date: Mon, 5 May 2008 13:31:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Scott White <nwi_sub@hotmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Please pull 'upstream' branch of rt2x00
Message-ID: <20080505173147.GA18429@tuxdriver.com> (sfid-20080505_195814_192469_91FF1505)
References: <BAY113-W31BC1B2DB0F0597B99310784DA0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BAY113-W31BC1B2DB0F0597B99310784DA0@phx.gbl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 02, 2008 at 04:04:52PM -0500, Scott White wrote:
> 
> >Was this patch series in time for the 2.6.26 merge window?
> >
> >If not, please consider merging at least the following patches since
> >they are real bugfixes:
> >
> >>       rt2x00: Don't enable short preamble for 1MBs
> >>       rt2x00: Fix quality/activity led handling
> >>       rt2x00: Clarify supported chipsets in Kconfig
> >
> >The others are code cleanups which are "nice to have", but could otherwise
> >wait for 2.6.27.
> 
> The merge window is still open at this time.  I haven't seen
> a rc1 yet.  Anyway I saw that only the 3 bugfixes are currently
> in the queue.  As the owner of several (10 by the university and
> 2 personal) rt73 usb wireless cards, I would really like it if the
> latest version 2.1.5 made into 2.6.26.  As someone who has used 2.6.24
> and finished compiling 2.6.25 two days ago I find that the driver in
> both kernels is not good.  Not good means I get a wireless signal and
> I get data transfers, but the speed fluctuates and have other issues.
> However with each release, the problems I have are slowing decreasing.
> I have been waiting patiently for 2.6.25-rc1 to have 2.1.5 since 2.1.5
> was announced.  I really think all of 2.1.5 should get in 2.6.25-rc1.

I'm sorry, but this isn't how the merge window is used.  The merge
window is for merging code that is _already_ pending when the
window opens.  No one should wait for the merge window to open before
sending code to the upstream maintainers.  (I'm not suggesting that
Ivo delayed on purpose, I'm just stating the policy.)

Anything that fixes an actual bug can still go to 2.6.26 over the
next several weeks.  But code that is simply new development will
have to wait for 2.6.27's merge window before it gets to Linus.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
