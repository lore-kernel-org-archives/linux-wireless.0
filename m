Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server.heaven-czfree.net ([78.108.102.201]:50638 "EHLO
	smtp.heaven-czfree.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab0EYUHk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 16:07:40 -0400
Received: from [10.23.202.43] (unknown [10.23.202.43])
	by smtp.heaven-czfree.net (Postfix) with ESMTP id 8BA78147682
	for <linux-wireless@vger.kernel.org>; Tue, 25 May 2010 22:07:38 +0200 (CEST)
From: "Jaroslav Fojtik" <jafojtik@seznam.cz>
To: linux-wireless@vger.kernel.org
Date: Tue, 25 May 2010 21:57:46 +0200
MIME-Version: 1.0
Subject: What does it mean: "Failed to create interface mon.wlan0."?
Message-ID: <4BFC2BBA.9348.415509@jafojtik.seznam.cz>
Content-type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Luis R. Rodriguez & ATH5k users,

> > it looks that compat-wireless-2010-05-21 scans when associated.
> >  But compat-wireless-2010-05-21 seems to be so defective that I cannot
> > use it.
> 
> http://wireless.kernel.org/en/users/Documentation/Reporting_bugs
> 
> Being a little more descriptive would help.
I wished to create a separate thread.

ATH5k stopped to work with this message in dmesg:

Failed to create interface mon.wlan0.
nl80211 driver initialization failed.


But ifconfig lists mon.wlan0 without any problem.
And compat-wireless-2.6.34-rc4 does not suffer with this issue.

regards
   Jara

