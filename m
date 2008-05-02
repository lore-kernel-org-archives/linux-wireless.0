Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s37.bay0.hotmail.com ([65.54.246.237]:50490 "EHLO
	bay0-omc3-s37.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965204AbYEBVLD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2008 17:11:03 -0400
Message-ID: <BAY113-W31BC1B2DB0F0597B99310784DA0@phx.gbl> (sfid-20080502_231048_102561_7623F690)
From: Scott White <nwi_sub@hotmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: Re: Please pull 'upstream' branch of rt2x00
Date: Fri, 2 May 2008 16:04:52 -0500
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>Was this patch series in time for the 2.6.26 merge window?
>
>If not, please consider merging at least the following patches since
>they are real bugfixes:
>
>>       rt2x00: Don't enable short preamble for 1MBs
>>       rt2x00: Fix quality/activity led handling
>>       rt2x00: Clarify supported chipsets in Kconfig
>
>The others are code cleanups which are "nice to have", but could otherwise
>wait for 2.6.27.

The merge window is still open at this time.  I haven't seen a rc1 yet.  Anyway I saw that only the 3 bugfixes are currently in the queue.  As the owner of several (10 by the university and 2 personal) rt73 usb wireless cards, I would really like it if the latest version 2.1.5 made into 2.6.26.  As someone who has used 2.6.24 and finished compiling 2.6.25 two days ago I find that the driver in both kernels is not good.  Not good means I get a wireless signal and I get data transfers, but the speed fluctuates and have other issues.  However with each release, the problems I have are slowing decreasing.  I have been waiting patiently for 2.6.25-rc1 to have 2.1.5 since 2.1.5 was announced.  I really think all of 2.1.5 should get in 2.6.25-rc1.

Thanks,
_________________________________________________________________
Windows Live SkyDrive lets you share files with faraway friends.
http://www.windowslive.com/skydrive/overview.html?ocid=TXT_TAGLM_WL_Refresh_skydrive_052008