Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:39186 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752501AbYHQOS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Aug 2008 10:18:26 -0400
Message-ID: <48A83333.6000400@lwfinger.net> (sfid-20080817_161829_920867_CC1AFD30)
Date: Sun, 17 Aug 2008 09:18:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: SuSE 11.0 & BCM4322 wifi, dv9925nr
References: <themagicm.3e9s1b@no-mx.forums.opensuse.org> <themagicm.3e9syn@no-mx.forums.opensuse.org> <themagicm.3e9tfb@no-mx.forums.opensuse.org> <themagicm.3e9utc@no-mx.forums.opensuse.org>
In-Reply-To: <themagicm.3e9utc@no-mx.forums.opensuse.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

themagicm wrote:
> lspci -n:
> 
> 03:00.0 0280: 14e4:432b (rev 01)

This is the first 432b that I have seen. I have no idea what it is, 
but I know that b43 does not support it. In fact, the Broadcom driver 
that I am currently reverse engineering does not support it either. 
Your only recourse is to use ndiswrapper.

Larry
