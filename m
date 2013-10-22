Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:37025 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab3JVTbC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Oct 2013 15:31:02 -0400
From: Alexandre Oliva <oliva@gnu.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: RTL8187B is racy
References: <or61sq3q4e.fsf@livre.home> <52669A94.3070600@lwfinger.net>
Date: Tue, 22 Oct 2013 17:30:47 -0200
In-Reply-To: <52669A94.3070600@lwfinger.net> (Larry Finger's message of "Tue,
	22 Oct 2013 10:32:36 -0500")
Message-ID: <ortxg985nc.fsf@livre.home> (sfid-20131022_213106_775174_FA75307D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Oct 22, 2013, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> After inspecting the code in rtl8187b_status_cb, I did notice that it
> does a lot of things that should be done by mac80211. As you have been
> testing code modifications, I assume that you will be able to test any
> patches that I generate.

Yeah, I can easily build and test patches here, at my workplace at home.
The only catch is that the module already works here; it seems to fail
only at busier environments, which I only get into once a month or so.
As long as we're not in much of a hurry, I can have things set up so
that, whenever I hit the problem with the module as it is now, I have a
patched module handy to test.  So, I'm looking forward to your patches
and/or suggestions on what else to try.  Just please make sure you Cc:
me, so that I won't miss it.

Thanks a lot!

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
