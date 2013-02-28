Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:54478 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab3B1CVr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 21:21:47 -0500
Received: by mail-wg0-f45.google.com with SMTP id dq12so1070628wgb.24
        for <linux-wireless@vger.kernel.org>; Wed, 27 Feb 2013 18:21:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130227192030.GW12537@pogo>
References: <1360329197-72631-1-git-send-email-nbd@openwrt.org>
	<20757.1753.863278.858198@gargle.gargle.HOWL>
	<511508A6.8020104@openwrt.org>
	<CAMcMvsjE=NNqt_q=vepZbFE8vwLypN2qZwyXg=aCBj3vvYOpMw@mail.gmail.com>
	<51152D9E.1040106@openwrt.org>
	<20130227192030.GW12537@pogo>
Date: Wed, 27 Feb 2013 18:21:46 -0800
Message-ID: <CAJ-VmonSQi1SZVrkvcuS8dubqSAy8s1RCGJounL1EA23z3FXzw@mail.gmail.com> (sfid-20130228_032151_304606_6F8A08EF)
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
From: Adrian Chadd <adrian@freebsd.org>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: Felix Fietkau <nbd@openwrt.org>, Paul Stewart <pstew@google.com>,
	Sujith Manoharan <sujith@msujith.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Why don't we just move the ath9k rate control code to another mac80211
rate control module, so it's available to other devices?

It may not be a bad idea to keep it around as a reference and for
people to do comparisons against. It just seems silly to have a rate
control framework and then not use it..


Adrian
