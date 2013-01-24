Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:40214 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3AXPve (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 10:51:34 -0500
Received: by mail-lb0-f176.google.com with SMTP id s4so4175066lbc.7
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2013 07:51:32 -0800 (PST)
From: Erwin Van de Velde <erwin.vandevelde@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Bypass EEPROM restrictions of Intel cards
Date: Thu, 24 Jan 2013 16:51:29 +0100
Message-ID: <2073047.fimZam72NC@sylvesterjr.pats.ua.ac.be> (sfid-20130124_165137_491476_B4EF5378)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I have an Intel Ultimate 6300 Ultimate-N wifi card and I was trying to do 
some wireless tests in the 5GHz band (2.4GHz is too polluted). However, the 
EEPROM does not allow ad-hoc mode in the 5GHz band, even though it is 
allowed here (Belgium). Is there anyway to circumvent this issue? 'iw reg set 
BE' does not help.

Best regards,
Erwin

