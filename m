Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:23171 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYHKRaB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 13:30:01 -0400
Received: by nf-out-0910.google.com with SMTP id d3so707803nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2008 10:30:00 -0700 (PDT)
Message-ID: <48A07709.80306@gmail.com> (sfid-20080811_193008_561505_E8FE5C9F)
Date: Mon, 11 Aug 2008 20:29:45 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Few questions about the wireless stack
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am trying to understand the relationship between
wireless interfaces (wlan0, mon0,..) and wireless driver.

The most important question I am after, is what types of interfaces I can
run simultaneously? 
(I know that I can run station and monitor, but what are other  combinations ?)

I noticed that in monitor mode iwl3945 appends so called 
'radiotap' header to received packets, but
it seems that mac80211 strips this header, and appends its own,
for monitor interfaces, if so, then why to append it?


And lastly, when you expect AP code to be released?


Best regards,
	Maxim Levitsky
