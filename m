Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:60858 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbZCNGxW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 02:53:22 -0400
Received: by fxm24 with SMTP id 24so2876416fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2009 23:53:19 -0700 (PDT)
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 5/7] p54: fix iwconfig txpower off
References: <200903052131.05450.chunkeey@web.de>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 14 Mar 2009 08:53:17 +0200
In-Reply-To: <200903052131.05450.chunkeey@web.de> (Christian Lamparter's message of "Thu\, 5 Mar 2009 21\:31\:05 +0100")
Message-ID: <871vt04mua.fsf@litku.valot.fi> (sfid-20090314_075324_390219_234B3FBA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@web.de> writes:

> Disabling the receiver logic with P54_FILTER_TYPE_RX_DISABLED is not
> supported by all firmwares. However we have an alternative: hibernation.
> And the only side effect - so far - is a bit less power consumption. WIN!

Some stlc45xx firmware versions had problems in waking up from
hibernation, but I think they were fixed at some point. Just a heads
up.

-- 
Kalle Valo
