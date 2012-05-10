Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:46242 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755612Ab2EJHLZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 03:11:25 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Soumik DAS <soumik.das@stericsson.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Increment probe_send_count earlier
References: <2E48302EED53D048A7BA72B0A307FB511FB9009098@EXDCVYMBSTM005.EQ1STM.local>
Date: Thu, 10 May 2012 10:11:21 +0300
In-Reply-To: <2E48302EED53D048A7BA72B0A307FB511FB9009098@EXDCVYMBSTM005.EQ1STM.local>
	(Soumik DAS's message of "Thu, 10 May 2012 07:46:40 +0200")
Message-ID: <87vck48q92.fsf@purkki.adurom.net> (sfid-20120510_091129_622637_97D7F93F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Soumik,

Soumik DAS <soumik.das@stericsson.com> writes:

> At times, null frame gets transmitted and acked before mac80211
> gets to increment probe_send_count. This leads to a situation
> where mac80211 waits for ack to null frame, but no ack comes
> causing unnecessary disconnection.

Can explain a bit more about the scenario when this happens, please?
It's not clear for me from the patch.

-- 
Kalle Valo
