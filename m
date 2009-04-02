Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:47226 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821AbZDBKor (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 06:44:47 -0400
Received: by bwz17 with SMTP id 17so441393bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 02 Apr 2009 03:44:44 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 2 Apr 2009 13:44:44 +0300
Message-ID: <dac45060904020344i7cc1bbafh663d257d90018cb1@mail.gmail.com> (sfid-20090402_124450_765013_5949DC5F)
Subject: Read country code from EEPROM
From: Mark Ryden <markryde@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
   I want to know what country code is written in the EEPROM  of an
Intel iwlwifi wireless card. (It is 5100AGN).

 should I probe into the driver code and add some printk messages?
or is there some util for it?

Regards,
Mark
