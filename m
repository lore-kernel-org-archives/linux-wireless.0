Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:49547 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3KAODd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:03:33 -0400
Received: by mail-we0-f179.google.com with SMTP id w61so3960956wes.38
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:03:32 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 00/23] wireless-regdb: general rules updates
Date: Fri,  1 Nov 2013 15:02:55 +0100
Message-Id: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150337_092921_D1BE6F11)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is my third series, it contains either just changes for
the 5 GHz band or changes to both the 2.4 GHz and 5 GHz band.
This will consist of removal of some frequency ranges so
special attention should be put to this series.

Luis R. Rodriguez (23):
  wireless-regdb: update BN's 5 GHz rules
  wireless-regdb: update CA's 5 GHz rules
  wireless-regdb: update KE's 5 GHz rules
  wireless-regdb: update KP's 5 GHz rules
  wireless-regdb: update MC's 5 GHz rules
  wireless-regdb: update MA's 5 GHz rules
  wireless-regdb: update NP's 5 GHz rules
  wireless-regdb: update OM's 5 GHz rules
  wireless-regdb: update PG's 5 GHz rules
  wireless-regdb: update RU's 5 GHz rules
  wireless-regdb: update RW's 5 GHz rules
  wireless-regdb: update SA's 5 GHz rules
  wireless-regdb: update TT's 5 GHz rules
  wireless-regdb: update ZA's 5 GHz rules
  wireless-regdb: update BG's regulatory rules
  wireless-regdb: update CO's regulatory rules
  wireless-regdb: update GE's regulatory rules
  wireless-regdb: update PR's regulatory rules
  wireless-regdb: update KR's regulatory rules
  wireless-regdb: update MX's regulatory rules
  wireless-regdb: update PA's regulatory rules
  wireless-regdb: update TW's regulatory rules
  wireless-regdb: update US'  regulatory rules

 db.txt | 133 ++++++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 70 insertions(+), 63 deletions(-)

-- 
1.8.4.rc3

