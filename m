Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f211.google.com ([209.85.217.211]:44622 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab0AGTFs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 14:05:48 -0500
Received: by gxk3 with SMTP id 3so7883461gxk.1
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2010 11:05:47 -0800 (PST)
Message-ID: <4B463088.1020000@lwfinger.net>
Date: Thu, 07 Jan 2010 13:05:44 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Tim Gardner <timg@tpi.com>
CC: mb@bu3sch.de, stefano.brivio@polimi.it,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Declare all possible firmware files.
References: <20100107183517.A322FF88D8@sepang.rtg.net>
In-Reply-To: <20100107183517.A322FF88D8@sepang.rtg.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/07/2010 12:35 PM, Tim Gardner wrote:
> The following changes since commit 2c1f1895ef2aa8f0e5497893eff71304aef332e1:
>   Linus Torvalds (1):
>         Merge branch 'drm-linus' of git://git.kernel.org/.../airlied/drm-2.6
> 
> are available in the git repository at:
> 
>   git://kernel.ubuntu.com/rtg/linux-2.6 b43
> 
> Tim Gardner (1):
>       b43: Declare all possible firmware files.
> 
>  drivers/net/wireless/b43/main.c |   34 ++++++++++++++++++++++++++++++++--
>  1 files changed, 32 insertions(+), 2 deletions(-)
> 
>>From def1157eaeb397f0afab25b91db8bab3fcb8816c Mon Sep 17 00:00:00 2001
> From: Tim Gardner <tim.gardner@canonical.com>
> Date: Thu, 7 Jan 2010 11:10:38 -0700
> Subject: [PATCH] b43: Declare all possible firmware files.
> 
> BugLink: http://bugs.launchpad.net/bugs/488636
> 
> Enhances module information with the names of the firmware files
> that could be used by this driver. This helps tools like Jockey to
> correctly detect and/or install the firmware files relevant to
> this driver.
> 
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---

How does Jockey do the firmware installation? I'm not familiar with this tool.

Larry

