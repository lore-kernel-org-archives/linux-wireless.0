Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42784 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3FDVaX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 17:30:23 -0400
Date: Tue, 4 Jun 2013 17:26:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
	Luciano Coelho <coelho@ti.com>
Subject: wireless tree rebased (from 5/28), Broadcom bits dropped
Message-ID: <20130604212602.GB11199@tuxdriver.com> (sfid-20130604_235307_771496_4C2FBAD1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All,

Due to my poor judgment in accepting the brcmfmac/brcmsmac series,
I've made a mess of the wireless tree.  To fix it, I have rebased from
before that series was applied.  I'm sure there were other potential
courses of action, but this is the one I chose...

If you maintain a tree that pulls from wireless.git (and has done
so within the past week), then you will need to rebase as well.
This is particularly true if you wish for me to pull from your tree
in the future.

I sincerely apologize for the inconvenience.  I hope that it won't
be happening again anytime soon (if at all).

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
