Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58672 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946115Ab3BHIuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 03:50:23 -0500
Message-ID: <1360313413.8166.1.camel@jlt4.sipsolutions.net> (sfid-20130208_095027_903252_AF277FF4)
Subject: Re: [PATCH] mac80211: Fix PN corruption in case of multiple virtual
 interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Amit SHAKYA <amit.shakya@stericsson.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>
Date: Fri, 08 Feb 2013 09:50:13 +0100
In-Reply-To: <ECD438FDEF6BD742895E554C24725A40236E825AFA@EXDCVYMBSTM005.EQ1STM.local>
References: <1359976737-28059-1-git-send-email-amit.shakya@stericsson.com>
	 <1359991708.10311.15.camel@jlt4.sipsolutions.net>
	 <ECD438FDEF6BD742895E554C24725A40236E82519C@EXDCVYMBSTM005.EQ1STM.local>
	 <201302061433.19375.chunkeey@googlemail.com>
	 <ECD438FDEF6BD742895E554C24725A40236E825AFA@EXDCVYMBSTM005.EQ1STM.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amit,


> Actually I debugged this issue quite some time back for a customer project. Now I don’t have the setup also as I have moved out of the project.
> 
> So I am afraid I will not be able to test it.

Ah, too bad.

Christian, I think regardless of that your version is much better, can
you send it?

Ben, maybe you've seen this as well, with your many interfaces
testing? :-)

johannes

