Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:52310
	"EHLO snark.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3FRFVW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 01:21:22 -0400
Received: from [127.0.1.1] (localhost [127.0.0.1])
	by snark.thyrsus.com (Postfix) with ESMTP id 3A21941765
	for <linux-wireless@vger.kernel.org>; Tue, 18 Jun 2013 01:13:52 -0400 (EDT)
Content-Type: multipart/mixed; boundary="===============5853243746613757781=="
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Problems in regulatory.bin.5
Message-Id: <20130618051352.3A21941765@snark.thyrsus.com> (sfid-20130618_072127_381560_532AC1E4)
Date: Tue, 18 Jun 2013 01:13:52 -0400 (EDT)
From: esr@thyrsus.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--===============5853243746613757781==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

This is automatically generated email about markup problems in a man
page for which you appear to be responsible.  If you are not the right
person or list, please tell me so I can correct my database.

See http://catb.org/~esr/doclifter/bugs.html for details on how and
why these patches were generated.  Feel free to email me with any
questions.  Note: These patches do not change the modification date of
any manual page.  You may wish to do that by hand.

I apologize if this message seems spammy or impersonal. The volume of
markup bugs I am tracking is over five hundred - there is no real
alternative to generating bugmail from a database and template.

--
                             Eric S. Raymond

--===============5853243746613757781==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Problems with regulatory.bin.5:

.SS markup in name section seriously confuses parsing, and sections
don't follow standard naming conventions.

--- regulatory.bin.5-unpatched	2012-07-02 01:57:14.437776710 -0400
+++ regulatory.bin.5	2012-07-02 01:59:11.117774528 -0400
@@ -2,12 +2,7 @@
 .SH NAME
 regulatory.bin \- The Linux wireless regulatory database
 
-.ad l
-.in +8
-.ti -8
-
-.SS
-.SH Description
+.SH DESCRIPTION
 .B regulatory.bin
 is the file used by the Linux wireless subsystem to keep its regulatory
 database information. It is read by
@@ -22,7 +17,7 @@
 .B regulatory.bin
 file should be updated upon regulatory changes or corrections.
 
-.SH Upkeeping
+.SH UPKEEP
 The regulatory database is maintained by the community as such
 you are encouraged to send any corrections or updates to the
 linux-wireless mailing list:

--===============5853243746613757781==--
