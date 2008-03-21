Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:53882 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYCUWPg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2008 18:15:36 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1747052wff.4
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2008 15:15:36 -0700 (PDT)
Message-ID: <aed435370803211515n5223a7aaob31339ed427a02cd@mail.gmail.com> (sfid-20080321_221541_134730_92DCA55F)
Date: Fri, 21 Mar 2008 15:15:36 -0700
From: "Rakesh Sinha" <rakesh.usenet@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: mac80211 - 10.0.4 - Kernel - 2.6.23.9-1mdv
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi -
  I am trying to build the mac80211 system on my Mandirva 2008 package.
Kernel -

# uname -a
Linux localhost 2.6.23.9-1mdv #1 Tue Nov 27 03:30:42 EST 2007 i686
Genuine Intel(R) CPU           T2060  @ 1.60GHz GNU/Linux

I am looking at the instructions available here -

http://intellinuxwireless.org/?p=mac80211&n=HOWTO-mac80211 .

After running make on 10.0.4 version of mac80211 - this is what I get
on the console.

----patch failure output-----
patching file net/mac80211/ieee80211.c
Hunk #1 FAILED at 2817.
Hunk #2 FAILED at 2838.
Hunk #3 FAILED at 2890.
Hunk #4 FAILED at 2975.
Hunk #5 FAILED at 2990.
Hunk #6 FAILED at 3003.
Hunk #7 FAILED at 3019.
7 out of 7 hunks FAILED -- saving rejects to file net/mac80211/ieee80211.c.rej

pending/0033-mac80211-fix-a-msdu-header.patch failed. Terminating.
If patch or script failed, check pre/ and post/ for current stage.
make: *** [modified] Error 1


Can somebody let me know what I am missing here.
Thanks for the help.
