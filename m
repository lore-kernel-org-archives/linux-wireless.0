Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:60928 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbXKFGkW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 01:40:22 -0500
Received: from [99.236.101.138] (helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1IpI6n-0001Jr-HS
	for linux-wireless@vger.kernel.org; Tue, 06 Nov 2007 01:40:22 -0500
Date: Tue, 6 Nov 2007 01:38:45 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: linux-wireless@vger.kernel.org
Subject: is net/mac80211/ieee80211_common.h being used?
Message-ID: <Pine.LNX.4.64.0711060136410.30254@localhost.localdomain> (sfid-20071106_064027_299099_72B25D2B)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


  hoping this is the right list, does that header file have any value
given that no one is including it?

$ grep -r ieee80211_common *
$

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
