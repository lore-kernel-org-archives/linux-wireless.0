Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.115.56]:39410 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753725Ab1AZUxi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 15:53:38 -0500
Received: from chimera.site ([173.50.240.230]) by xenotime.net for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 12:53:34 -0800
Date: Wed, 26 Jan 2011 12:53:34 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: James <bjlockie@lockie.ca>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: no CONFIG_WIRELESS_EXT
Message-Id: <20110126125334.ca40d495.rdunlap@xenotime.net>
In-Reply-To: <4D40774A.608@lockie.ca>
References: <4D40774A.608@lockie.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 26 Jan 2011 14:34:34 -0500 James wrote:

> I installed compat-wireless-2011-01-25 and iwlist doesn't work but iw does.
> The warning dmesg shows is "cfg80211: wext will not work because kernel
> was compiled with CONFIG_WIRELESS_EXT=n. Tools using wext interface,
> like iwconfig will not work." which is fine BUT my kernel is compiled with
> CONFIG_WIRELESS=y
> CONFIG_WIRELESS_EXT_SYSFS=y
> and those are the only 2 'WIRELESS' anything.
> 
> I have kernel 2.6.36.3.

How about /WEXT/ anything?

I guess that you also have CONFIG_WEXT_CORE enabled?


I don't know about the tools issue though.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
