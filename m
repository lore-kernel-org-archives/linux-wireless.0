Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nat-warsl417-01.aon.at ([195.3.96.119]:35557 "EHLO email.aon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751938AbYL0U6p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Dec 2008 15:58:45 -0500
Received: from smarthub92.highway.telekom.at (HELO email.aon.at) ([172.18.5.231])
          (envelope-sender <der.claudio@aon.at>)
          by fallback43.highway.telekom.at (qmail-ldap-1.03) with SMTP
          for <linux-wireless@vger.kernel.org>; 27 Dec 2008 20:52:03 -0000
To: linux-wireless@vger.kernel.org
Subject: status of at76-usb driver
Message-ID: <1230411118.4956956ecb911@webmail.aon.at> (sfid-20081227_215850_986184_066EB103)
Date: Sat, 27 Dec 2008 21:51:58 +0100 (CET)
From: Claudio <der.claudio@aon.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

Since my hardware stopped working properly due to a distro (ubuntu btw) upgrade and I was not able to quickly fix it, I started investigating (again) in \"the case of at76-usb\" and read through this mailing-list, the wiki and had a look at the changes in the git tree. I am not sure if I understood everything correctly.

Can anyone sum up what the current state for users of at76-usb devices is please?

It seems like the working code has been removed from the kernel in order to rewrite it anywhere in the future and adapt it to this new mac80211 thing. Which means that currently users (like me) have to use an old version of linux (like 2.4.22) to make use of their devices. Hopefully I am wrong...

Kalle, Milan, Dan, <else>?

Regards,

Claudio
