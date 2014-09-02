Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:49867 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaIBHwg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 03:52:36 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
	by mail-out.m-online.net (Postfix) with ESMTP id 3hnL9H4zd3z3hhw6
	for <linux-wireless@vger.kernel.org>; Tue,  2 Sep 2014 09:52:35 +0200 (CEST)
Received: from mail.display-solution.com (mail.display-solution.com [82.135.126.210])
	by mail.mnet-online.de (Postfix) with ESMTP id 3hnL9H2wfhzvjMx
	for <linux-wireless@vger.kernel.org>; Tue,  2 Sep 2014 09:52:35 +0200 (CEST)
Received: from sbs2003.DisplaySolution.local by company.mail
	(MDaemon Standard v9.5.4)
	with ESMTP id md50000388822.msg
	for <linux-wireless@vger.kernel.org>; Tue, 02 Sep 2014 09:53:33 +0200
Subject: Intel 4965AGN - Android Implementation for Boundary SabreLite mini PCIe, Android 4.3
Date: Tue, 2 Sep 2014 09:52:31 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Message-ID: <F653787480BF5A439D4259B266FA81686A89D2@sbs2003.DisplaySolution.local> (sfid-20140902_095240_073725_48423A77)
From: "Michael Greger" <mgreger@display-solution.com>
To: <linux-wireless@vger.kernel.org>
Cc: <ilw@linux.intel.com>, <sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Sir or Madam,

my name is Michael from Gilching near Munich in Germany. We are using the sabreLite for Digital Signage purposes and want to use the Intel 4965AGN miniPCIe module on the SabreLite. The Sabre Lite is an Android board with the Freescale i.MX6q (Arm) processor. 
My intention is to get the WIFI module running on my board. I found the article "How to enable PCIe WiFi into i.MX6 Android Release" , but this helps not much.
-	First thing is that I need the file iwlwifi4965-2.ucode file, appropriate for my Android 4.3, kernel 3.0.35 system.
-	Then, what module do I need in the kernel, iwlagn or iwl4965 or both?


Do you have any working code for the 4965AGN under an  iMX6 system under Android 4.3?

Many thanks and best regards,
Michael


Mit freundlichen Grüßen
Michael Greger
____________________________________________________
 

 
Michael Greger
Dipl. Ing. (FH) 
Entwicklung

Display Solution AG
Talhofstr. 32
82205 Gilching
Deutschland

Tel:  +49 (0) 81 05 / 7 34 03 -33
Fax: +49 (0) 81 05 / 7 34 03 -79
E-Mail: mgreger@display-solution.com    
Web: www.display-solution.com 
Handelsregister: Augsburg HRB 22144
Vorstandsvorsitzender: Norbert Feuchtgruber
Vorstand: Günther Hirschberger, Norbert Erhart, René Auer
Aufsichtratsvorsitzende: Gabriele Erhart


Diese Nachricht ist vertraulich und nur für den Adressaten bestimmt. 
Sollten Sie irrtümlich diese Nachricht erhalten haben, bitte ich um Ihre 
Mitteilung per E-Mail oder unter oben angegebener Telefonnummer


