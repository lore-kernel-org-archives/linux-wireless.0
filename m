Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49303 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbcGRTWj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 15:22:39 -0400
Message-ID: <1468869757.2944.6.camel@sipsolutions.net> (sfid-20160718_212241_879382_0F1168D3)
Subject: Re: [PATCH v2] cfg80211: Allow differnt beacon interval if driver
 supports
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
	Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	usdutt@qti.qualcomm.com, ganeshk@qti.qualcomm.com,
	mkalikot@qca.qualcomm.com, amarnath@qca.qualcomm.com
Date: Mon, 18 Jul 2016 21:22:37 +0200
In-Reply-To: <fd7fc930-67ab-89bf-5909-0851057e0c84@broadcom.com> (sfid-20160718_212117_571267_7B0E65D8)
References: <1468849985-6881-1-git-send-email-pkushwah@qti.qualcomm.com>
 <1468868209.2944.1.camel@sipsolutions.net>
 <9831c426-ae04-a85f-9173-bcea30c489d7@broadcom.com>
 <1468869356.2944.5.camel@sipsolutions.net>
	 <fd7fc930-67ab-89bf-5909-0851057e0c84@broadcom.com>
	 (sfid-20160718_212117_571267_7B0E65D8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Whoops. Should not use abbreviations like that. I meant the
> Multiple-BSSID functionality (from hostapd):

Ah, heh. Yes, I think this is exactly the use case they have in mind.
Each of the multiple BSSes is represented by its own AP type virtual
interface.

johannes

