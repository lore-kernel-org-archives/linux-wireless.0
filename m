Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:40794 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758575AbXI0XIN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 19:08:13 -0400
Message-ID: <46FC37D8.3000800@lwfinger.net>
Date: Thu, 27 Sep 2007 18:08:08 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Ivo van Doorn <ivdoorn@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: RF-kill support
References: <200709272135.35686.mb@bu3sch.de> <200709272303.57040.mb@bu3sch.de> <46FC2BE9.2050705@lwfinger.net> <200709280033.35765.mb@bu3sch.de>
In-Reply-To: <200709280033.35765.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> One or two days, maybe.
> I'm currently debugging another important bug.
> And I guess I'll have to sleep in an hour or two, too. :)
> 
> The rfkill fix will be incremental based on this one, then.
> 

That I expected. The way I should have stated the question was "Should I submit the port of this
patch to b43legacy ASAP, or should I wait until the rfkill fix is ready to have only 1 rather than 2
patches for John to handle?" I think the correct answer is to wait. It will probably take me that
long to verify my port of the new LED handler anyway.

Larry

