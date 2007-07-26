Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mi0.bluebottle.com ([206.188.25.15]:33353 "EHLO
	mi0.bluebottle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759964AbXGZPLD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 11:11:03 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by mi0.bluebottle.com (8.13.1/8.13.1) with ESMTP id l6QFB2jK015121
	for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2007 08:11:02 -0700
Message-Id: <200707261511.l6QFB2jK015121@mi0.bluebottle.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Jul 2007 08:10:58 -0700
From: Axj <axjslack@bluebottle.com>
Subject: Re: Request for help...
References: <1185289332.46a61474a444c@mail.bluebottle.com> <1185355931.3131.13.camel@debian.sh.intel.com>
In-Reply-To: <1185355931.3131.13.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Zhu Yi <yi.zhu@intel.com>:

> On Tue, 2007-07-24 at 08:02 -0700, Axj wrote:
> > so I can't compile the new version, but, even if the compilation
> is
> > not finished, when I retried to compile iwl version 0.1.2, it
> works.
> > Now for me is impossible to  understand, and I'm tring the way to
> make
> > mac802 subsys work. Can anyone help me....
> 
> iwlwifi-0.1.3 fixed this problem.
> 
> Thanks,
> -yi
> 

I tried, but peraphs I do someting wrong.... In fact without mac80211-9.0.x is impossibile to compile iwlwifi-0.1.3. But for me I'ts impossible to compile mac-802-9.0.2... give me 2 compile errors when I do "make modules", in the wmc.c. Now, if use the "make patch_kernel" of version of 9.0.2 and compile iwlwifi-0.1.3 it copilke perfect but at the moment to load the module, search a Object that doesn't exist (because if I don't compile the 9.0.2 I have to use 8.0.2). So, if I undestood good, the only way to use the driver version 0.1.x and not the version 0.0.x, is to make work the mac80211 version 9.0.2, and to resolve the compilation problem. It's no so simply like seems to be.

I  saw onother exit of thje driver, 1.0.0, but I don't trust so much (at the momente the compination of mac80211 ver 8.0.2 and iwlwifi-0.0.42 work, even if the led doesn't work ad It's impossible to set an "Ad-Hoc" connection. ) so I would like try a CVS or GIT version of the Mac80211 or newer.... I know that a lot of person think that I have to "learn to fish", but I'm a better systemist, but not a excellent programmer (expecially in kernel space). 

I would like to tel You tank you for the help.... 
I hope that one day I will give you as better answer....

----------------------------------------------------------------------
Finally - A spam blocker that actually works.
http://www.bluebottle.com/tag/4

