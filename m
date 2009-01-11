Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:34856 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751547AbZAKRKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jan 2009 12:10:25 -0500
Message-ID: <496A27FA.5030508@lwfinger.net> (sfid-20090111_181100_563123_30D8FBDE)
Date: Sun, 11 Jan 2009 11:10:18 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jayant Sane <jayant_sane@hotmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Newbie question on 2.6.28-rc8-wl
References: <BLU129-W39120C9D5D733AC53C210180DB0@phx.gbl>
In-Reply-To: <BLU129-W39120C9D5D733AC53C210180DB0@phx.gbl>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jayant Sane wrote:
> Bear with a miserable newbie... 
>  
> I have been asked to compile against the 2.6.28-rc8-wl version of kernel (as printed by uname -r). How and where can I get this specific kernel version from? 
>  
> I figured how to get the patch for 2.6.28-rc8 but the "-wl" part stumps me. 

That is the kernel from the wireless-testing git tree. The only way to
get it is to install the git package from your distro and issue the
command

git clone \
git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git


Be aware that the download is roughly 200 MB. In addition, the above
will get you 2.6.28-wl. If you really need -rc8 (which I doubt), then
you will need to issue the additional command

git checkout v2.6.28-rc8

The -wl part is not needed here.

Larry

