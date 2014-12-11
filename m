Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934353AbaLKQhK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2014 11:37:10 -0500
From: Jes.Sorensen@redhat.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH v2 0/1] mac80211: Avoid accessing uninitialized stack data
Date: Thu, 11 Dec 2014 11:37:03 -0500
Message-Id: <1418315824-23753-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20141211_173716_868844_F9A7D61F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

Per Johannes' suggestion, here is a v2 of the patch, avoiding
accessing uninitialized stack variables when a driver announces HT
support without also advertising 40MHz+ support.

Cheers,
Jes

Jes Sorensen (1):
  wireless: mac80211: Avoid using uninitialized stack data

 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
1.9.3

