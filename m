Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:59932 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbZBRRd5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 12:33:57 -0500
Received: by fg-out-1718.google.com with SMTP id 16so889122fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2009 09:33:55 -0800 (PST)
To: linux-wireless@vger.kernel.org
Subject: Mysterious IWLWIFI_SPECTRUM_MEASUREMENT config
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 18 Feb 2009 19:33:52 +0200
Message-ID: <87d4df1wfz.fsf@litku.valot.fi> (sfid-20090218_183401_423721_2DA3722F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was doing my usual practise of recompiling my kernel and again I was
asked this question:

Enable Spectrum Measurement in iwlagn driver
(IWLWIFI_SPECTRUM_MEASUREMENT) [N/y/?] (NEW)

Ok, so I chose '?' and got this:

"This option will enable spectrum measurement for the iwlagn driver."

Not a very helpful message. I have few kind requests:

1) Please write a proper description for the option.

2) Recommend a proper default value: "If you don't have a clue what
   this is, choose N".

3) Please consider even removing the option. Is it really needed?

-- 
Kalle Valo
