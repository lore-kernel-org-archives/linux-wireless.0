Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lax-green-bigip-5.dreamhost.com ([208.113.200.5]:34605 "EHLO
	swarthymail-a7.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752831AbYGaRnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 13:43:05 -0400
Received: from on6jc.ampr.org (host120.201-252-129.telecom.net.ar [201.252.129.120])
	by swarthymail-a7.g.dreamhost.com (Postfix) with ESMTP id 4E5A6DE58F
	for <linux-wireless@vger.kernel.org>; Thu, 31 Jul 2008 10:42:42 -0700 (PDT)
Date: Thu, 31 Jul 2008 14:42:09 -0300
From: John Coppens <john@jcoppens.com>
To: linux-wireless@vger.kernel.org
Subject: regdomain setting
Message-Id: <20080731144209.58c53424.john@jcoppens.com> (sfid-20080731_194309_641138_2D392E7D)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi guys...

I've tried to check the regdomain in my Toshiba, which has an
AR5212-based WiFi card installed, using the ar5k utility. It reports
EEPROM timeout when trying to read.

I checked the baseaddress to be 0xcfee0000 with lspci -v, and executed
the command  ./ar5k 0xcfee0000

I tried with and without the ath5k kernel module loaded. Kernel is 2.6.26

Am I doing something wrong here?

John
