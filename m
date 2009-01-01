Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:35033 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756828AbZAAQij (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jan 2009 11:38:39 -0500
Message-ID: <495CF183.10107@lwfinger.net> (sfid-20090101_173856_692688_5BC9951C)
Date: Thu, 01 Jan 2009 10:38:27 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	=?ISO-8859-1?Q?Stefanik_?= =?ISO-8859-1?Q?G=E1bor?=
	<netrolller.3d@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org,
	linux-pm@lists.linux-foundation.org,
	USB list <linux-usb@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: [linux-pm] rtl8187 usb wifi adaptor causes suspend hang
References: <120849.67182.qm@web23104.mail.ird.yahoo.com>
In-Reply-To: <120849.67182.qm@web23104.mail.ird.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> 
> Yes, that's the (older) non-B device. B devices says RTL8187Bv{B,D,E} . with a B before the 7; I have a rev E .The B device and the non-B device while similiar enough to share some driver code, are different enough that
> they might suspend/resume differently - they do probe/init slightly differently. Besides, I think all the people who recently worked on that code are B-device owners, with maybe Larry who probably owns both types (or a few).

I only have one. It is the strange device that reports an 8187 USB ID,
but is really an 8187B.

Larry
