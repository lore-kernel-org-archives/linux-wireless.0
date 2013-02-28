Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f175.google.com ([209.85.210.175]:57599 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab3B1Lr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 06:47:27 -0500
Received: by mail-ia0-f175.google.com with SMTP id r4so1397585iaj.20
        for <linux-wireless@vger.kernel.org>; Thu, 28 Feb 2013 03:47:27 -0800 (PST)
Date: Thu, 28 Feb 2013 06:47:24 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Adrian Chadd <adrian@freebsd.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>,
	Sujith Manoharan <sujith@msujith.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
Message-ID: <20130228114724.GB16369@localhost> (sfid-20130228_124731_811500_02A5A386)
References: <1360329197-72631-1-git-send-email-nbd@openwrt.org>
 <20757.1753.863278.858198@gargle.gargle.HOWL>
 <511508A6.8020104@openwrt.org>
 <CAMcMvsjE=NNqt_q=vepZbFE8vwLypN2qZwyXg=aCBj3vvYOpMw@mail.gmail.com>
 <51152D9E.1040106@openwrt.org>
 <20130227192030.GW12537@pogo>
 <CAJ-VmonSQi1SZVrkvcuS8dubqSAy8s1RCGJounL1EA23z3FXzw@mail.gmail.com>
 <512ECE01.8010102@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <512ECE01.8010102@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 28, 2013 at 04:24:49AM +0100, Felix Fietkau wrote:
> On 2013-02-28 3:21 AM, Adrian Chadd wrote:
> > It may not be a bad idea to keep it around as a reference and for
> > people to do comparisons against. It just seems silly to have a rate
> > control framework and then not use it..
> I don't see the point in keeping that algorithm around. It has known
> design flaws that make it perform poorly in several scenarios, and
> fixing some of the flaws require basically rewriting it.

The same could be said of PID...

-- 
Bob Copeland %% www.bobcopeland.com
