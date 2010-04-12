Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f197.google.com ([209.85.223.197]:53675 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab0DLOrg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 10:47:36 -0400
Received: by iwn35 with SMTP id 35so1097057iwn.21
        for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 07:47:34 -0700 (PDT)
Message-ID: <4BC33283.1030706@lwfinger.net>
Date: Mon, 12 Apr 2010 09:47:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: reinette chatre <reinette.chatre@intel.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	"lee_matheson@hotmail.com" <lee_matheson@hotmail.com>
Subject: Good work on driver for iw5300agn
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In http://bugzilla.novell.com/show_bug.cgi?id=592399, a problem was
reported for a 5300. After the openSUSE 11.3 Milestones switched to
2.6.34, the comment below was posted: Thanks to all the Intel crew for
their good work.

Larry

==================

--- Comment #7 from Lee Matheson <lee_matheson@hotmail.com> 2010-04-12
05:34:02 UTC ---
A final contribution, with 11.3 build0553 64-bit KDE liveCD, I left my
laptop running with the wireless connection for 16 hours continuous and
the Internet/wireless stayed connected all the time, albeit there were
many of the above described disconnects followed by reconnected. But
they were too fast to be noticeable and could only be seen by looking at
dmesg.

With the above patch my view is with the 2.6.34 kernel the Intel 5300AGN
behaves much better than it ever did with the earlier kernels in 11.1
and 11.2.  Assuming this build 0553 is representative of what we will
see in 11.3 and that there is no regression in behaviour between
build-0553 and 11.3 GM, I'm happy for this bug report to be closed.
