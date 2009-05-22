Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:31355 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbZEVFKM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 01:10:12 -0400
Received: by fk-out-0910.google.com with SMTP id 18so679758fkq.5
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2009 22:10:13 -0700 (PDT)
To: "ffileppo" <ffileppo@libero.it>
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: Re: mac80211: TDMA approach feasible?
References: <KJXSX4$879353F1086C26A62039759B06C868B9@libero.it>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 22 May 2009 08:10:10 +0300
In-Reply-To: <KJXSX4$879353F1086C26A62039759B06C868B9@libero.it> (ffileppo@libero.it's message of "Wed\, 20 May 2009 11\:55\:52 +0200")
Message-ID: <87ws89vi31.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"ffileppo" <ffileppo@libero.it> writes:

> Hi all,

Hello,

> I was wondering if with mac80211 is now possible (and what effort is
> needed) to implement a TDMA approach. In particular I would like to:
> override 802.11 MPDU frame format, eliminate RTS/CTS exchange,
> eliminate automatic ACK and retransmission, eliminate virtual carrier
> sense (NAV), control PHY clear channel assessment and control
> transmission backoff.

Most of this is usually implemented in firmware, so you need access to
firmware sources.

-- 
Kalle Valo
