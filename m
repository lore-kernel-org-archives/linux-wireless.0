Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:45919 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757846Ab2B2PwR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 10:52:17 -0500
Message-ID: <4F4E47BC.8000306@mlbassoc.com> (sfid-20120229_165221_313061_B1046115)
Date: Wed, 29 Feb 2012 08:43:56 -0700
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Help building compat-wireless
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm struggling a bit to build compat-wireless in a cross-build environment.
I normally don't build kernels in-tree, rather I use a build tree, e.g.
   % cd <linux-source>
   % mkdir /tmp/kernel_build
   % make O=/tmp/kernel_build <some_config>
   % make O=/tmp/kernel_build uImage

I can't see how to use this setup with the compat-wireless package.
I tried [all the combinations I could think of] something like this:
   % cd <compat-wireless>
   % make KLIB=<linux-source> KLIB_BUILD=/tmp/kernel_build
However, this seems to not work as all I get are errors like this:
   /local/compat-wireless-2012-02-28/config.mk:242: "WARNING: CONFIG_CFG80211_WEXT will be deactivated or not working because kernel was compiled with CONFIG_WIRELESS_EXT=n. Tools 
using wext interface like iwconfig will not work. To activate it build your kernel e.g. with CONFIG_LIBIPW=m."

Does this process work in my workflow?  What do I need to do to
get it going?

Thanks

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
