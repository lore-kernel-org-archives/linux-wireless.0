Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54767 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab3KAN6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:58:00 -0400
Received: by mail-wi0-f172.google.com with SMTP id ez12so1106333wid.11
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:57:59 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 00/65] wireless-regdb: enable VHT80, extend 5 GHz ranges
Date: Fri,  1 Nov 2013 14:56:50 +0100
Message-Id: <1383314275-20960-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_145804_498579_D18834AD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is my second series of patches, this covers only augmentive
changes changes to enable HT40, VHT80 or increase power and extend
the 5 GHz frequency ranges.

Luis R. Rodriguez (65):
  wireless-regdb: enable HT40  for AL on 2.4 GHz
  wireless-regdb: enable VHT80 for AM
  wireless-regdb: enable VHT80 for AN
  wireless-regdb: enable VHT80 for AW
  wireless-regdb: enable VHT80 for AZ
  wireless-regdb: enable VHT80 for BA
  wireless-regdb: enable VHT80 for BB
  wireless-regdb: enable VHT80 for BH
  wireless-regdb: enable VHT80 for BO
  wireless-regdb: enable VHT80 for BY
  wireless-regdb: enable VHT80 for BZ
  wireless-regdb: enable VHT80 for CL
  wireless-regdb: enable VHT80 for CY
  wireless-regdb: enable VHT80 for EE
  wireless-regdb: enable VHT80 for EG
  wireless-regdb: enable VHT80 for GE
  wireless-regdb: enable VHT80 for HN
  wireless-regdb: enable VHT80 for HR
  wireless-regdb: enable VHT80 for HT
  wireless-regdb: enable VHT80 for HU
  wireless-regdb: enable VHT80 for GL
  wireless-regdb: enable VHT80 for IN
  wireless-regdb: enable VHT80 for IS
  wireless-regdb: enable VHT80 for IR
  wireless-regdb: enable VHT80 for JM
  wireless-regdb: enable VHT80 for JO
  wireless-regdb: enable VHT80 for LI
  wireless-regdb: enable VHT80 for LK
  wireless-regdb: enable VHT80 for LT
  wireless-regdb: enable VHT80 for LV
  wireless-regdb: enable VHT80 for MK
  wireless-regdb: enable VHT80 for MT
  wireless-regdb: enable VHT80 for KH
  wireless-regdb: enable VHT80 for PK
  wireless-regdb: enable VHT80 for QA
  wireless-regdb: enable VHT80 for RO
  wireless-regdb: enable VHT80 for SI
  wireless-regdb: enable VHT80 for SV
  wireless-regdb: enable VHT80 for TN
  wireless-regdb: enable VHT80 for NO
  wireless-regdb: enable VHT80 for DO
  wireless-regdb: enable VHT80 for GT
  wireless-regdb: enable VHT80 for UZ
  wireless-regdb: enable VHT80 for VE
  wireless-regdb: enable VHT80 for UY
  wireless-regdb: add VHT80 rules for AL
  wireless-regdb: add VHT80 rules for BD
  wireless-regdb: add VHT80 rules for LB
  wireless-regdb: add VHT80 rules for CN
  wireless-regdb: add VHT80 rules for UA
  wireless-regdb: add VHT80 rules for DZ
  wireless-regdb: add VHT80 rules for ZW
  wireless-regdb: extend 5 GHz range for AE
  wireless-regdb: extend 5 GHz range for AR
  wireless-regdb: extend 5 GHz range for BR
  wireless-regdb: extend 5 GHz range for CR
  wireless-regdb: extend 5 GHz range for EC
  wireless-regdb: extend 5 GHz range for GU
  wireless-regdb: extend 5 GHz range for NZ
  wireless-regdb: extend 5 GHz range for VN
  wireless-regdb: extend 5 GHz range for PE
  wireless-regdb: extend 5 GHz range for PH
  wireless-regdb: extend 5 GHz range for SG
  wireless-regdb: extend 5 GHz range for TH
  wireless-regdb: increase 5   GHz power for IL

 db.txt | 294 +++++++++++++++++++++++++++++++++++------------------------------
 1 file changed, 157 insertions(+), 137 deletions(-)

-- 
1.8.4.rc3

