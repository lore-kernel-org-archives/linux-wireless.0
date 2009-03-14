Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:8086 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989AbZCNUET (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 16:04:19 -0400
Received: by nf-out-0910.google.com with SMTP id d21so858221nfb.21
        for <linux-wireless@vger.kernel.org>; Sat, 14 Mar 2009 13:04:17 -0700 (PDT)
Message-ID: <49BC0DBE.90209@gmail.com> (sfid-20090314_210441_865219_A75732D9)
Date: Sat, 14 Mar 2009 21:04:14 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ids missing in ath5k ?
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

why these ids are not supported in ath5k ? 

       { 0x168c, 0x101a, PCI_ANY_ID, PCI_ANY_ID }, /* some Griffin-Lite */
       { 0x168c, 0x9013, PCI_ANY_ID, PCI_ANY_ID }, /* sonicwall */


They are included in madwifi driver! Are there more of them missing ?


-thanks-


regards,
-- 
Polycommander, Erkowit, Urquiola, Andros Patria, Cason, Aegean Sea, Prestige, ...
