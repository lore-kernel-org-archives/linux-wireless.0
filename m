Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59751 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbaASUwR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jan 2014 15:52:17 -0500
Message-ID: <52DC3AF7.4060606@hauke-m.de> (sfid-20140119_215222_274669_BF4F8511)
Date: Sun, 19 Jan 2014 21:52:07 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "backports@vger.kernel.org" <backports@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: kernel freezes when insmoding iwldvm.ko from backports-20140117
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

when I insmoding iwldvm.ko from backports-201400117 my kernel freezes
and does not show any error message. This problem started with
backports-20140106, backports-20131224 works for me.

I am using the Ubuntu kernel 3.5.0-45 someone else with the same problem
uses kernel 3.2.0. I am using a Intel 6300.
Someone reported that an Atheros card worked, so this is probably a
problem in iwlwifi.

Hauke
