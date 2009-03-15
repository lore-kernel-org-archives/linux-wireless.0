Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:64826 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337AbZCOPZb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2009 11:25:31 -0400
Message-ID: <49BD1DE5.3020905@lwfinger.net> (sfid-20090315_162535_490429_56EAC8C4)
Date: Sun, 15 Mar 2009 10:25:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hinkocevar <hinkocevar@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: bcm4311 gentoo problems
References: <49BCEBF0.8010006@gmail.com>
In-Reply-To: <49BCEBF0.8010006@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hinkocevar wrote:
> 
> Any comments?

Very few. You obviously have the firmware loading correctly and you do not have
an RFKILL switch set. My experience has been that BCM4311/1 cards just work.

Please post the output of 'iwlist scan'. I don't use Gentoo and do not know
which directory contains iwlist. Is your AP in the list?

My guess would be a configuration problem. The common ones are trying to use a
passphrase rather than the hex key with WEP, failing to have wpa_supplicant
installed, or failing to prepare the proper files when ifconfig is used.

Larry
