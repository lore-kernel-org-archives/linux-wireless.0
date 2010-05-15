Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23103.mail.ird.yahoo.com ([217.146.189.43]:31078 "HELO
	web23103.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755179Ab0EOLVb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 May 2010 07:21:31 -0400
Message-ID: <717061.22086.qm@web23103.mail.ird.yahoo.com>
Date: Sat, 15 May 2010 11:21:28 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH 1/2] wireless: rtl818x: rtl8180: add ids
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	herton@mandriva.com.br, Larry.Finger@lwfinger.net
In-Reply-To: <4BEE7AB0.2090206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Sat, 15/5/10, Xose Vazquez Perez <xose.vazquez@gmail.com> wrote:

> Sorry, but no realtek devices here.

I am sorry, if you do not own any of the devices for which you just copied a bunch of IDs from the windows driver, that means your patch is untested. What is your purpose of copying IDs from the windows driver? 

There is no code sharing between the windows driver and the linux driver, and there are at least 5 variants of the device - so what the windows driver supports really bears no relationship with what the linux driver supports.
I don't think it is a good idea to blindly copy IDs from the windows driver without testing.




      
