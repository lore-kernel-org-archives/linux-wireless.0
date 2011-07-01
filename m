Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:45603 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605Ab1GATaJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 15:30:09 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1QcjPi-0008La-Bw
	for linux-wireless@vger.kernel.org; Fri, 01 Jul 2011 21:30:06 +0200
Received: from 216.125.91.252 ([216.125.91.252])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jul 2011 21:30:06 +0200
Received: from ant2ne by 216.125.91.252 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jul 2011 21:30:06 +0200
To: linux-wireless@vger.kernel.org
From: ant2ne <ant2ne@gmail.com>
Subject: Re: carl9170 and debian squeeze
Date: Fri, 1 Jul 2011 19:25:16 +0000 (UTC)
Message-ID: <loom.20110701T212014-423@post.gmane.org> (sfid-20110701_213013_718194_2C91E02E)
References: <AANLkTimL=JSK6jcF4d97Nc-vLZdeRLj8o=MbpCas-H7z@mail.gmail.com> <28292.82403.qm@web56807.mail.re3.yahoo.com> <AANLkTi=GgTWU1QmoqxM_rA8jUX7814PvZqsEGvcnc6ps@mail.gmail.com> <AANLkTi=OcXfoo8gFQ+qTYDgL4XaKXiGZpUSSiL8yT_ho@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Was there ever a solution for this?

I continue to get the "Unknown symbol in module" error. I've got squeeze with 
2.6.32-5 kernel
and I've tried a variety of compat-wireless versions including the latest 3.0 
stable. 
I've tried by building with out a specified driver-select (which took awhile) 
and I've tried with specifying carl9170.

