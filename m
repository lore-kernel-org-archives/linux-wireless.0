Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62199 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab2CON73 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 09:59:29 -0400
Received: by eaaq12 with SMTP id q12so1540276eaa.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2012 06:59:27 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 15 Mar 2012 13:59:27 +0000
Message-ID: <CAGUfO+wJd8wdcwzaigV=DYzhCNt8cNtWc4P=MoXJLd9ozHyPjg@mail.gmail.com> (sfid-20120315_145933_601091_9647B8FA)
Subject: signal strength in nl80211 and IEEE80211_HW_SIGNAL_UNSPEC
From: Cristian Morales Vega <cristian@samknows.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I don't have a device using a driver with IEEE80211_HW_SIGNAL_UNSPEC
to test, but because of
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=19deffbeba930030cfaf000b920333c6ba99ad52
I guess nl80211 will report the NL80211_STA_INFO_SIGNAL even if the
driver doesn't uses dBm, true?
Looking at http://permalink.gmane.org/gmane.linux.kernel.wireless.general/24814
it seems this wasn't wanted. Bug, the check for
IEEE80211_HW_SIGNAL_DBM is done elsewhere or finally it was decided
that the signal strength should be reported even if the units are
unknown?

Thanks.

-- 
Cristian Morales Vega

Email cristian@samknows.com
Office +44 (0) 20 3111 4330
Direct Line:  +44 (0) 20 3111 4338
Web:  www.samknows.com


This email is sent for and on behalf of SamKnows Limited.

This email and any attachments are confidential, legally privileged
and protected by copyright. If you are not the intended recipient
dissemination or copying of this email is prohibited. If you have
received this in error, please notify the sender by replying by email
and then delete the email completely from your system.

SamKnows Limited, Registered Number: 06510477, Registered Office: 25
Harley Street, London, W1G 9BR. Registered in England and Wales. Trade
Mark 2507103
