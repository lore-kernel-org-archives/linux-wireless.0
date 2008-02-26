Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:56354 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbYBZNcf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 08:32:35 -0500
To: bruno randolf <bruno@thinktube.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath5k bf=xxx bf_skb=0 warnings
References: <m3ve4cqtfy.fsf@maximus.localdomain>
	<200802261511.25472.bruno@thinktube.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 26 Feb 2008 14:32:34 +0100
In-Reply-To: <200802261511.25472.bruno@thinktube.com> (bruno randolf's message of "Tue\, 26 Feb 2008 15\:11\:25 +0900")
Message-ID: <m33arfaln1.fsf@maximus.localdomain> (sfid-20080226_133237_972234_DEF49D66)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bruno randolf <bruno@thinktube.com> writes:

> yes, that's normal and harmless. i haven't got around to make a smarter 
> solution yet.
>
> that's because we call ath5k_beacon_config() each time after a channel is set 
> or the chip is reset, even if the beacon has not been configured yet.

I see, thanks.
-- 
Krzysztof Halasa
