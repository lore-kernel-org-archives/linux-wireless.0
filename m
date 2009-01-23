Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:64437 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296AbZAWFc4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 00:32:56 -0500
Message-ID: <4979567D.2020005@lwfinger.net> (sfid-20090123_063300_660813_B9DC773B)
Date: Thu, 22 Jan 2009 23:32:45 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Alina Friedrichsen <x-alina@gmx.net>, samuel@sortiz.org,
	Kalle Valo <kalle.valo@iki.fi>, maximlevitsky@gmail.com,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression caused by commit	e32b1b9a33759e8a83ac566c4c43f23ed5d6343b
References: <4979269F.1060500@lwfinger.net> <20090123021413.GB3177@tuxdriver.com>
In-Reply-To: <20090123021413.GB3177@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> 
> I reverted this in wireless-testing (and it never went anywhere
> upstream).  Of course, now it looks like Samuel has a fix...maybe
> I'll combine them...

Samuel's fix works for me.

Larry
