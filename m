Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:7921 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758512AbYDCNYR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 09:24:17 -0400
Received: by wa-out-1112.google.com with SMTP id v27so3644163wah.23
        for <linux-wireless@vger.kernel.org>; Thu, 03 Apr 2008 06:24:16 -0700 (PDT)
Message-ID: <a44ae5cd0804030624u40be9ad9rb1cadefadb13f889@mail.gmail.com> (sfid-20080403_142500_363034_CE408D97)
Date: Thu, 3 Apr 2008 09:24:16 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211 -- My log files are filling up with: "wlan0: RX non-WEP frame, but expected encryption"
Cc: "Jiri Benc" <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <a44ae5cd0804030615n3c3e906ey1db4513802bdf01@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <a44ae5cd0804021732s6ae5ed81ma5e229ae0faf4aaf@mail.gmail.com>
	 <1207226756.3636.66.camel@johannes.berg>
	 <a44ae5cd0804030615n3c3e906ey1db4513802bdf01@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks.  I think I have a working build, but can you confirm that the
linker messages are benign?
I will get to work now on getting the log for you.

Now I get:
# make
 CC   iw.o
cc: -lnl: linker input file unused because linking not done
 CC   interface.o
interface.c: In function 'handle_interface':
interface.c:64: warning: 'err' may be used uninitialized in this function
interface.c:64: note: 'err' was declared here
interface.c:138: warning: 'err' may be used uninitialized in this function
interface.c:138: note: 'err' was declared here
cc: -lnl: linker input file unused because linking not done
 CC   info.o
cc: -lnl: linker input file unused because linking not done
 CC   station.o
cc: -lnl: linker input file unused because linking not done
 CC   util.o
cc: -lnl: linker input file unused because linking not done
 CC   mpath.o
cc: -lnl: linker input file unused because linking not done
 CC   iw
