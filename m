Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:33919 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750968AbYFYO6F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 10:58:05 -0400
Message-ID: <48625D39.30700@lwfinger.net> (sfid-20080625_165809_743280_3E622520)
Date: Wed, 25 Jun 2008 09:59:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
CC: "John W. Linville" <linville@tuxdriver.com>,
	herton@mandriva.com.br, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, andreamrl@tiscali.it, linville@redhat.com
Subject: Re: [RFC][PATCH] Realtek 8187B wireless support with product id	0x8197/0x8189
References: <922158.32180.qm@web23114.mail.ird.yahoo.com> <20080625140809.GA9111@tuxdriver.com>
In-Reply-To: <20080625140809.GA9111@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> 
> Thanks for your effort on this issue.  I am very proud of the way you
> and others have participated in improving this patch as documented
> in the bugzilla link above.
> 
> I apologize for having been slow to respond but I seem to constantly
> be buried in patches...  That is even more true today since I have
> recently been on vacation.  Still, this patch has been languishing
> in my mailbox too long!
> 
> Please review the guidelines here:
> 
>    http://linux.yyz.us/patch-format.html
> 
> If possible, please wrap your changelog comment lines at 80 columns
> or less.  Also you should probably include Signed-off-by lines from
> Herton and Pavel.  And please include the patch inline if possible
> for easier review -- use a mailer that preserves whitespace correctly.
> 
> I may have more specific comments about the patch itself later, but now
> I really need to get caught-up on some other merging.  I just wanted to
> ensure that you knew I was not (completely) ignoring your efforts! :-)

I have been using this patch on my Level 1 WNC-0301USB device. There 
are still problems with the TX code as it can associate only about 1 
try in 10, but RX seems to be fine. I have been too busy to sort out 
the problems, but I have fixed the patch to get rid of checkpatch 
warnings and errors, which includes the "Signed-off-by" lines.

Would you like me to send the updated version to you, or should I send 
it to linux-wireless and John?

Larry
