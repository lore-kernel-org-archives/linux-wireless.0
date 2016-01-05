Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fbr01-uk.csee.siteprotect.eu ([81.3.27.131]:38077 "EHLO
	fbr01-uk.csee.siteprotect.eu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487AbcAEObZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 09:31:25 -0500
Received: from smtpauth01-uk.csee.siteprotect.eu (unknown [192.168.22.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "smtp.securepod.com", Issuer "RapidSSL SHA256 CA - G3" (not verified))
	by fbr01-uk.csee.siteprotect.eu (Postfix) with ESMTPS id 200744114E
	for <linux-wireless@vger.kernel.org>; Tue,  5 Jan 2016 15:31:24 +0100 (CET)
Received: from Authenticated sender: roger@beardandsandals.co.uk
	by smtpauth01-uk.csee.siteprotect.eu (Postfix) with ESMTPSA id 00D8C407CE
	for <linux-wireless@vger.kernel.org>; Tue,  5 Jan 2016 15:31:23 +0100 (CET)
To: linux-wireless@vger.kernel.org
From: Roger James <roger@beardandsandals.co.uk>
Subject: Is there any way to read the current state of the flags on a monitor
 mode interface
Message-ID: <568BD3BA.9080205@beardandsandals.co.uk> (sfid-20160105_153128_842226_58EF78C0)
Date: Tue, 5 Jan 2016 14:31:22 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Can anyone please tell me if there is any way to read the current state 
of the monitor flags on a interface. Whatever I do I never seem to get 
the NL80211_ATTR_MNTR_FLAGS attribute returned.

Someone take pity on me please, this is driving me nuts :-)

Roger
