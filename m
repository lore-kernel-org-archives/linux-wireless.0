Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n9a.bullet.ukl.yahoo.com ([217.146.183.157]:24441 "HELO
	n9a.bullet.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751250AbYFYPnL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 11:43:11 -0400
Message-ID: <486267C7.8020801@yahoo.co.uk> (sfid-20080625_174315_230626_A8E23616)
Date: Wed, 25 Jun 2008 16:44:07 +0100
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
CC: herton@mandriva.com.br, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, andreamrl@tiscali.it, linville@redhat.com
Subject: Re: [RFC][PATCH] Realtek 8187B wireless support with product id	0x8197/0x8189
References: <922158.32180.qm@web23114.mail.ird.yahoo.com> <20080625140809.GA9111@tuxdriver.com> <48625D39.30700@lwfinger.net>
In-Reply-To: <48625D39.30700@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(am still not on linux-wireless, please cc: when replying...)
Larry Finger wrote:
> John W. Linville wrote:
<snipped>
>> I may have more specific comments about the patch itself later, but now
>> I really need to get caught-up on some other merging.  I just wanted to
>> ensure that you knew I was not (completely) ignoring your efforts! :-)

Great - I have checked out the whole git of wireless-testing a few days ago
and will try to find some time to track down how some of the recent changes
elsewhere broke, and do some of the stuff 'properly'.

> I have been using this patch on my Level 1 WNC-0301USB device. There are 
> still problems with the TX code as it can associate only about 1 try in 
> 10, but RX seems to be fine. I have been too busy to sort out the 
> problems, but I have fixed the patch to get rid of checkpatch warnings 
> and errors, which includes the "Signed-off-by" lines.
> 
> Would you like me to send the updated version to you, or should I send 
> it to linux-wireless and John?

Both and/or attaching to the redhat bugzilla :-). (have as many people
seeing/testing...) There is a newer vendor driver out from the one Herton based
on, so that might fix something; also the control queue switching I mentioned in
the my forward port effort may have something to do with that.

Cheers, and looking forward to moving this forward :-).
Hin-Tak

