Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41129 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab3B1NJi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 08:09:38 -0500
Message-ID: <512F5709.60907@openwrt.org> (sfid-20130228_140943_954900_67EE0CBB)
Date: Thu, 28 Feb 2013 14:09:29 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Adrian Chadd <adrian@freebsd.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>,
	Sujith Manoharan <sujith@msujith.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
References: <1360329197-72631-1-git-send-email-nbd@openwrt.org> <20757.1753.863278.858198@gargle.gargle.HOWL> <511508A6.8020104@openwrt.org> <CAMcMvsjE=NNqt_q=vepZbFE8vwLypN2qZwyXg=aCBj3vvYOpMw@mail.gmail.com> <51152D9E.1040106@openwrt.org> <20130227192030.GW12537@pogo> <CAJ-VmonSQi1SZVrkvcuS8dubqSAy8s1RCGJounL1EA23z3FXzw@mail.gmail.com> <512ECE01.8010102@openwrt.org> <20130228114724.GB16369@localhost>
In-Reply-To: <20130228114724.GB16369@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-02-28 12:47 PM, Bob Copeland wrote:
> On Thu, Feb 28, 2013 at 04:24:49AM +0100, Felix Fietkau wrote:
>> On 2013-02-28 3:21 AM, Adrian Chadd wrote:
>> > It may not be a bad idea to keep it around as a reference and for
>> > people to do comparisons against. It just seems silly to have a rate
>> > control framework and then not use it..
>> I don't see the point in keeping that algorithm around. It has known
>> design flaws that make it perform poorly in several scenarios, and
>> fixing some of the flaws require basically rewriting it.
> 
> The same could be said of PID...
I agree, we should remove that one as well.

- Felix

