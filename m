Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from router.emperor-sw2.exsbs.net ([208.254.201.37]:44430 "EHLO
	sade.emperorlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbZKTXEV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 18:04:21 -0500
Received: from [192.168.1.196] (dhcp196.emperorlinux.com [192.168.1.196])
	by sade.emperorlinux.com (Postfix) with ESMTP id 235887EA800
	for <linux-wireless@vger.kernel.org>; Fri, 20 Nov 2009 16:29:54 -0500 (EST)
Subject: iwlagn + Ad-Hoc + 5Ghz
From: Jeremy Moles <jeremy@emperorlinux.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Fri, 20 Nov 2009 17:37:27 -0500
Message-Id: <1258756647.2714.17.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello all! I have a group of machine here with an app that needs to set
up an ad-hoc network in 5Ghz+ range. The machines themselves are all
different (a Panasonic, a Dell, and a Lenovo) but they are all using
5100 cards, a 2.6.31 kernel, and the 2.6.31-rc7 driver from the website.

Using the command "iw list" I can get a lot of helpful info, but I see
"no IBSS" on any channel over 11, and I'm beginning to think that this
just isn't supported on these cards yet. Am I right here, or is it in
fact supported and I am just missing something? Could the hardware,
perhaps, be configured on a very low level to not allow something like
this?

Thanks in advance. :)

