Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:36871 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbZDJEez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2009 00:34:55 -0400
Received: by bwz17 with SMTP id 17so881415bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 09 Apr 2009 21:34:53 -0700 (PDT)
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Another regression in 2.6.30-rc1
References: <49DE1638.8060906@lwfinger.net>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 10 Apr 2009 07:34:52 +0300
In-Reply-To: <49DE1638.8060906@lwfinger.net> (Larry Finger's message of "Thu\, 09 Apr 2009 10\:37\:28 -0500")
Message-ID: <873achunwz.fsf@litku.valot.fi> (sfid-20090410_063458_477179_F2708FD6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> If you are implementing kernel 2.6.30-rc1 from wireless-testing, there is a
> regression that will hit you if you have the ACPI battery routines enabled. The
> symptom is an oops on boot with the line "> BUG: unable to handle kernel NULL
> pointer dereference at (null)". The patch for this, which comes from
> 2.6.30-rc1-git1 in Linus's tree, is as follows:

Thanks Larry, this was very helpful. After cherry picking this commit
wireless-testing is booting without errors for me.

In general sharing regressions and workarounds in this list is a very
good idea. I'm sure most of the people (including me) don't have time to
follow lkml and find fixes for all regressions.

-- 
Kalle Valo
