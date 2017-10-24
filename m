Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr30086.outbound.protection.outlook.com ([40.107.3.86]:45024
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751566AbdJXJDL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Oct 2017 05:03:11 -0400
To: <wireless-regdb@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>
From: Per Mejdal Rasmussen <pmr@its.aau.dk>
Subject: Update regulatory rules for Denmark (DK) on 2.4 and 5GHz
Message-ID: <25548470-bf47-3827-6aa3-de4684d66f12@its.aau.dk> (sfid-20171024_110316_376981_59A63CD4)
Date: Tue, 24 Oct 2017 11:03:06 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

The content of db.txt for Denmark (DK) is wrong. The 5GHz is from some 
where between 2002-2006, and the 2.4GHz has never been correct.

Current content of db.txt:
--------------------------
country DK: DFS-ETSI
	(2402 - 2482 @ 40), (20)
	(5170 - 5250 @ 80), (20), AUTO-BW
	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
	(5490 - 5710 @ 160), (27), DFS
	# 60 GHz band channels 1-4, ref: Etsi En 302 567
	(57000 - 66000 @ 2160), (40)


Current free channels Denmark:
------------------------------
2400,0-2483,5 MHz
5150,0-5350,0 MHz
5470,0-5725,0 MHz
5725,0-5875,0 MHz
57-66 GHz


I suggest to copy the rules for Germany (DE) to Denmark (DK):
-------------------------------------------------------------
country DK: DFS-ETSI
	(2400 - 2483.5 @ 40), (100 mW)
	(5150 - 5250 @ 80), (100 mW), NO-OUTDOOR, AUTO-BW
	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS, AUTO-BW
	(5470 - 5725 @ 160), (500 mW), DFS
	# short range devices (ETSI EN 300 440-1)
	(5725 - 5875 @ 80), (25 mW)
	# 60 GHz band channels 1-4 (ETSI EN 302 567)
	(57000 - 66000 @ 2160), (40)


History of free channels Denmark:
---------------------------------

 From 1999-09-07:
2400,0-2483,5 MHz
5150,0-5250,0 MHz

 From 2000-03-30
2400,0-2483,5 MHz
5150,0-5350,0 MHz

 From 2002-12-10
2400,0-2483,5 MHz
5150,0-5350,0 MHz
5470,0-5725,0 MHz
17,1-17,3 GHz

 From 2006-11-07
2400,0-2483,5 MHz
5150,0-5350,0 MHz
5470,0-5725,0 MHz
5725,0-5925,0 MHz
17,1-17,3 GHz

 From 2007-09-20
2400,0-2483,5 MHz
5150,0-5350,0 MHz
5470,0-5725,0 MHz
5725,0-5875,0 MHz
17,1-17,3 GHz

 From 2008-06-11
2400,0-2483,5 MHz
5150,0-5350,0 MHz
5470,0-5725,0 MHz
5725,0-5875,0 MHz

 From 2009-11-27 (current)
2400,0-2483,5 MHz
5150,0-5350,0 MHz
5470,0-5725,0 MHz
5725,0-5875,0 MHz
57-66 GHz

Source (search for "RLAN"):
https://www.retsinformation.dk/Forms/R0710.aspx?id=189932



-- 
Per Mejdal Rasmussen
http://personprofil.aau.dk/109070
