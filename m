Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.htl-leonding.ac.at ([192.88.24.5]:38824 "EHLO
	postla2.htl-leonding.ac.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401AbYE3OiI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 10:38:08 -0400
From: Michael Grundmann <mgrundmann@htl-leonding.ac.at>
To: linux-wireless@vger.kernel.org
Subject: Re: suspend vs. b43
Date: Fri, 30 May 2008 16:31:56 +0200
References: <1212150713.4117.2.camel@johannes.berg>
In-Reply-To: <1212150713.4117.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805301631.56899.mgrundmann@htl-leonding.ac.at> (sfid-20080530_163811_438107_A856D3A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I can reproduce this too on my HP6715s 
(b43-phy2: Broadcom 4311 WLAN found
b43-phy2 debug: Found PHY: Analog 4, Type 2, Revision 9
b43-phy2 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2)
it hangs while hibernating with tuxonice.


> Does anyone have a machine with b43 in it that can suspend and supports
> the RTC-trace feature so we can narrow it down? Even reproducing might
> help to make sure it's not just something weird with my powerbook.



