Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41016 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab3K0QeX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 11:34:23 -0500
Date: Wed, 27 Nov 2013 11:33:35 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org
Subject: [ANN] wireless-regdb: master-2013-11-27
Message-ID: <20131127163334.GB7780@tuxdriver.com> (sfid-20131127_173426_012540_334F880E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A new release of wireless-regdb (master-2013-11-27) is available at:

http://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-2013.11.27.tar.gz

Here is the short log of the changes included since the 2013-10-11
release:

John W. Linville (2):
      Actually sign regulatory.bin with the correct key...
      wireless-regdb: update regulatory.bin based on preceding changes.

Luis R. Rodriguez (96):
      wireless-regdb: consolidate passive-scan and no-ibss flags
      wireless-regdb: remove antenna gain
      wireless-regdb: add DFS FCC regions
      wireless-regdb: add DFS ETSI regions
      wireless-regdb: add DFS JP regions
      wireless-regdb: optimize two of DE's rules
      wireless-regdb: optimize two of IL's rules
      wireless-regdb: optimize two of NL's rules
      wireless-regdb: enable HT40 for AL on 2.4 GHz
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
      wireless-regdb: increase 5 GHz power for IL
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
      wireless-regdb: update US' regulatory rules

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
