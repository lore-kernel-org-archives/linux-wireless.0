Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:42193 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab2EFSyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2012 14:54:16 -0400
Date: Sun, 06 May 2012 14:53:04 -0400 (EDT)
Message-Id: <20120506.145304.1998242927519675381.davem@davemloft.net> (sfid-20120506_205421_496402_52AC9851)
To: dh.herrmann@googlemail.com
Cc: gustavo@padovan.org, linville@tuxdriver.com,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Fix coding style
From: David Miller <davem@davemloft.net>
In-Reply-To: <CANq1E4TTfDxZPsOqqWUT7PqTKUr8nCTC-wo=iGe_pxoUmnecgQ@mail.gmail.com>
References: <1336157988-4602-1-git-send-email-gustavo@padovan.org>
	<20120506.123656.1335354317428258137.davem@davemloft.net>
	<CANq1E4TTfDxZPsOqqWUT7PqTKUr8nCTC-wo=iGe_pxoUmnecgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Herrmann <dh.herrmann@googlemail.com>
Date: Sun, 6 May 2012 19:46:46 +0200

> Whose rules are they?

Find me an example in another major core subsystem, let's use
mm/memory.c as an example as that file gets hit by a lot of people,
that uses the multi-line conditional TAB-only crap you guys seem to
keep using.

They don't.  All the examples you'll find are of the form:

	if (a &&
	    b)

not:

	if (a &&
			b)

like I see happening in bluetooth all the time.

How did you think they figured that out?  Did they read someone's
mind?
