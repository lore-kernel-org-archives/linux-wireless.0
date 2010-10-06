Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37930 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758997Ab0JFPaF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 11:30:05 -0400
Date: Wed, 6 Oct 2010 11:27:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Jaeger <chrjae@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: Why were patches reverted on 2010-09-21? (carl9170 and others)
Message-ID: <20101006152716.GF2472@tuxdriver.com>
References: <AANLkTin9hFUE_RH0Zb4OuV2dU_kJs6_ap=VxEmT3e3F8@mail.gmail.com>
 <20101006132301.GA2472@tuxdriver.com>
 <AANLkTi=1-r8XZHn9nqbbh2N=7yrsKXZbgxHNcNg+qFxo@mail.gmail.com>
 <AANLkTi=buSXukPp4xeSdig6z3rvNs2G=v6s1Y794Q2JK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <AANLkTi=buSXukPp4xeSdig6z3rvNs2G=v6s1Y794Q2JK@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 06, 2010 at 11:07:12AM -0400, Christian Jaeger wrote:
> Thanks for your explantion.
> 
> My patches on top of the stable kernel don't build (they depend a
> 'cipher' member on ‘struct ieee80211_key_conf’, and I guess there may
> be more). If I want to reach my goal of trying carl9170 with a stable
> kernel, should I still proceed that route, i.e. finding the patches
> that carl* depends on, or trying to change the carl* code to not
> require them, or is there a better idea? I'd like to avoid running
> wireless-testing as is if possible (for fear of stability and security
> issues on this world-facing, supposedly stable router of mine).

You might try the compat-wireless stuff on top of whatever kernel
you are using.

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
