Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38702 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbbATTDQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2015 14:03:16 -0500
Message-ID: <54BEA673.3010709@candelatech.com> (sfid-20150120_200328_666624_182A124F)
Date: Tue, 20 Jan 2015 11:03:15 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: New ath10k CT firmware beta available.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For any of you using my ath10k CT firmware, please consider testing out the
latest beta.  I plan to make this the official -013 release unless problems
are found in our regression or reported by others.


The main changes since the 012 release are:

* Add IBSS/AHDOC support.
* Work-around tx-credits hang due to WMI/CE lockup in firmware.
* Attempt to fix a few (rarely seen) asserts reported by users (scan code, resource-mgr, etc)


To download:

http://www.candelatech.com/downloads/ath10k-fw-beta/


More general info on this firmware:

http://www.candelatech.com/ath10k.php


For full feature support, you might try my 3.19 kernel.  It has less testing than
the 3.17, but it has been stable enough so far.

http://dmz2.candelatech.com/git/gitweb.cgi?p=linux-3.19.dev.y/.git;a=summary

git clone git://dmz2.candelatech.com/linux-3.19.dev.y


Please let me know how it goes if you try out this firmware.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

