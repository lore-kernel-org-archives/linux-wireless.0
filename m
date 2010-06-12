Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:4227 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab0FLRwI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 13:52:08 -0400
Subject: Re: Compilation problems with Linux-2.6.34 and compat-wireless
From: Pavel Roskin <proski@gnu.org>
To: Jaroslav Fojtik <jafojtik@seznam.cz>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4C108B0F.12989.BAFA3@jafojtik.seznam.cz>
References: <4C108B0F.12989.BAFA3@jafojtik.seznam.cz>
Content-Type: text/plain
Date: Sat, 12 Jun 2010 13:51:58 -0400
Message-Id: <1276365118.2625.25.camel@ct>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-06-10 at 08:49 +0200, Jaroslav Fojtik wrote:
> Dear John W. Linville,
> 
> > I'm guessing you need CONFIG_WIRELESS_EXT in /usr/src/linux-2.6.34/.config ?
> I do not know how to turn CONFIG_WIRELESS_EXT in linux 2.6.34. 
> This option no longer exists.

Try enabling an older driver like ipw2100.  That should enable wireless
extensions.

> I guess that:
> CONFIG_WIRELESS_EXT=y  has been renamed to 
> CONFIG_WIRELESS_WEXT=y

I don't see any references to WIRELESS_WEXT in the kernel.  I think your
guess is wrong.

-- 
Regards,
Pavel Roskin
