Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:49781 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457Ab3IJR7t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 13:59:49 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: regulatory will stuck when cfg80211 is built-in
References: <CAFSJ42bTQkQO+yugN7BBjygQd7LY9H0bPBoPfoH7yyfyMzuGqA@mail.gmail.com>
	<87ppshu5mr.fsf@purkki.adurom.net>
	<CAFSJ42b_jOJA7ABK7GqDi0KO-Nnv-8CvhMC6ysTicPhe00kS=w@mail.gmail.com>
Date: Tue, 10 Sep 2013 20:59:48 +0300
In-Reply-To: <CAFSJ42b_jOJA7ABK7GqDi0KO-Nnv-8CvhMC6ysTicPhe00kS=w@mail.gmail.com>
	(Eugene Krasnikov's message of "Tue, 10 Sep 2013 18:23:23 +0200")
Message-ID: <87d2ogtv57.fsf@purkki.adurom.net> (sfid-20130910_195957_976669_AB458B5F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eugene Krasnikov <k.eugene.e@gmail.com> writes:

> No, the flag CONFIG_CFG80211_INTERNAL_REGDB  does not help and it should not.
>
> The problem is that cfg80211 will stuck in situation when cfg80211 is
> initialized before user space. One way to get cfg80211 out of this
> state is to run crda once right after user space is up and running.
> But again is this intentional? Or it is more like a workaround?

With the internal regdb you do not need crda anymore, so why does it still
get stuck? Where does it exactly get stuck?

-- 
Kalle Valo
