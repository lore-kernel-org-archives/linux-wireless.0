Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:7314 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757616AbYFZTTt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 15:19:49 -0400
Subject: Re: [RFC][PATCH] Realtek 8187B wireless support with product id
	0x8197/0x8189
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Hin-Tak Leung <hintak_leung@yahoo.co.uk>,
	Matthew Garrett <mjg@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	herton@mandriva.com.br, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, andreamrl@tiscali.it, linville@redhat.com
In-Reply-To: <4863E113.1040609@lwfinger.net>
References: <779389.39286.qm@web23108.mail.ird.yahoo.com>
	 <48630FE7.7060800@lwfinger.net> <4863D05A.7070801@yahoo.co.uk>
	 <4863E113.1040609@lwfinger.net>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 14:44:54 -0400
Message-Id: <1214505894.18729.11.camel@dv> (sfid-20080626_212021_748847_D067F467)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-06-26 at 13:33 -0500, Larry Finger wrote:

> Do I understand correctly that it might be better to check for the 
> existence of endpoint 02 for an 8187 device? Or would it be better to 
> look for endpoint 12 to set it as an 8187B?

It's probably OK either way, but I would look at some number that takes
more than just 2 values (true and false).  Say, the number of endpoints
would be such number.  This way, it there is some elusive 8187A or
8187C, it may have a different number and won't be mistaken for known
chipsets.

Of course, we cannot guarantee anything.  It's just a matter of general
sanity that may or may not help.  But sometimes it helps.

-- 
Regards,
Pavel Roskin
