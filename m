Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53125 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab3DPNaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 09:30:10 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1US5xX-0003vy-Ka
	for linux-wireless@vger.kernel.org; Tue, 16 Apr 2013 15:30:08 +0200
Message-ID: <1366119003.8244.12.camel@jlt4.sipsolutions.net> (sfid-20130416_153015_603749_F3C420E2)
Subject: Re: [PATCH 0/8] mac80211: improve channel switch handling
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 16 Apr 2013 15:30:03 +0200
In-Reply-To: <1365597822-27660-1-git-send-email-johannes@sipsolutions.net> (sfid-20130410_144351_624560_74A574BC)
References: <1365597822-27660-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130410_144351_624560_74A574BC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-10 at 14:43 +0200, Johannes Berg wrote:
> This improves channel switch handling to actually parse a lot of
> the newer messages and the new bandwidth (including VHT.)

Applied.

johannes

