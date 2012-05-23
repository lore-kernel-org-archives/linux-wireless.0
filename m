Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:49700 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757651Ab2EWKoE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 06:44:04 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: allow setting default U-APSD queues/max_sp_len for STA
References: <1337760813-27055-1-git-send-email-arik@wizery.com>
Date: Wed, 23 May 2012 13:44:02 +0300
In-Reply-To: <1337760813-27055-1-git-send-email-arik@wizery.com> (Arik
	Nemtsov's message of "Wed, 23 May 2012 11:13:33 +0300")
Message-ID: <87wr436utp.fsf@purkki.adurom.net> (sfid-20120523_124410_328779_E0994858)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arik Nemtsov <arik@wizery.com> writes:

> Allow the low level driver to set U-APSD parameters when operating in
> managed mode.

Why? I assume there is a reason for this...

-- 
Kalle Valo
