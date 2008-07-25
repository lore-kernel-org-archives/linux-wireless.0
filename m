Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n57.bullet.mail.sp1.yahoo.com ([98.136.44.49]:44946 "HELO
	n57.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751407AbYGYPUN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2008 11:20:13 -0400
Date: Fri, 25 Jul 2008 08:20:09 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
Reply-To: free_beer_for_all@yahoo.com
Subject: WLAN regression before this morning
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <761713.15647.qm@web46115.mail.sp1.yahoo.com> (sfid-20080725_172020_750788_4C6D7AD1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Servus,

Last successfully built and used kernel was 2.6.26-rc8, about
the start of 29.Jun UTC or so.

Present build of GIT 2.6.26 during the merge window, updated
just before 06h UTC, today, 25.Jul.

With today's kernel, I am not even able to associate with a
WLAN less than two metres away from my ZD1211rw type USB
adapter, to say nothing of more distant WLANs with which I
could authenticate with the earlier code without problems --
I don't even come near the associate stage.

The networks all show up as expected in `iwlist wlan1 scan'
with decent strengths; while all I get from dmesg is
[ 1016.829827] wlan1: authenticate with AP 00:1X:YZ:AB:23:45
[ 1017.032769] wlan1: authenticate with AP 00:1X:YZ:AB:23:45
[ 1017.234213] wlan1: authenticate with AP 00:1X:YZ:AB:23:45
[ 1017.435402] wlan1: authentication with AP 00:1X:YZ:AB:23:45 timed out


If I've hosed myself with a new .config option, I'll be kicking
meself where it hurts most.  Else, back to -rc8 to both send
this message and to regain 'net access to do other needed so-
called `work', so sorry I haven't narrowed this down further...

And I'll feel me a fool if the failure is because I went from
a different (BSD) OS into 2.6.26-merge, while going from that
into -rc8 I promptly associate as desired.


thanks
barry bouwsma


      

