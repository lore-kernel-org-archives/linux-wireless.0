Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:53851 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753056AbZAWPfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 10:35:08 -0500
Message-ID: <4979E3A0.6000003@lwfinger.net> (sfid-20090123_163513_317320_836D43C1)
Date: Fri, 23 Jan 2009 09:34:56 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Fix driver to return TX retry info for RTL8187L
References: <49790961.JdcKIZyYlMNFSiuO%Larry.Finger@lwfinger.net> <4979DD39.9000601@hauke-m.de>
In-Reply-To: <4979DD39.9000601@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hauke Mehrtens wrote:
> 
> I have tested this patch in compat-wireless-2009-01-23 (kernel 2.6.27,
> ubuntu) with my rtl8187 card (build on Asus P5B Delux Wifi, 0bda:8187
> Realtek Semiconductor Corp. RTL8187 Wireless Adapter) and for me it does
> not work.
> 
> With this patch I get a connection to the AP, but the bandwidth is very
> low. After a reboot it was connected to the AP, but the connection was
> unusable for me, no traffic went through the connection at all.

What is your status without this patch? Is your connection stable at 1
Mb/s?

With the patch, what rate did iwconfig report, and which rate-setting
algorithm are you using?

Larry
