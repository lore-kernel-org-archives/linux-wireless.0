Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3982 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147Ab1GGAUo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 20:20:44 -0400
Date: Wed, 6 Jul 2011 17:20:34 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: linville@tuxdriver.com, gregkh@suse.de,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
cc: "Henry Ptasinski" <henryp@broadcom.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Zhenhui Lin" <frankyl@broadcom.com>
Subject: [RFC] Move brcm80211 to mainline
Message-ID: <20110707002034.GA17885@broadcom.com> (sfid-20110707_022048_807252_FCC4C223)
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the latest series of cleanup patches merged in by Greg KH, I'd like to now
propose moving brcm80211 out of staging and into mainline.

Since brcm80211 in staging-next has about ~250 patches that areen't in
wireless-testing yet, I've put together a patch to add a copy of the current
sources from staging-next into wireless-testing:drivers/net/wireless/brcm80211.

The patch is somewhat large, so I've posted the patch at:

	http://linuxwireless.org/en/users/Drivers/brcm80211?action=AttachFile&do=get&target=0001-wireless-testing-add-brcm80211.patch

Only the necessary Kconfig and Makefile adjustments have been made (the sources
are unchanged from what's currently in staging-next).

- Henry


