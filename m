Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40389 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519AbbLGTpR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2015 14:45:17 -0500
Date: Mon, 7 Dec 2015 14:39:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Subject: wireless-testing rebased, new HEAD commit
 f5feec4244464225c03ccc9ddad615cb43a044cc
Message-ID: <20151207193910.GB27529@tuxdriver.com> (sfid-20151207_204523_033930_1122DE90)
References: <87fuzkf2ef.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87fuzkf2ef.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All,

An earlier pull got a version of mac80211.git that was later reverted.
Unfortunately, the intervening merges got things so screwed-up I
couldn't reasonably unravel them.  So, I have taken the somewhat
unusual step of rebasing wireless-testing here in the middle of the
4.4 stream.

The current wireless-testing HEAD is commit
f5feec4244464225c03ccc9ddad615cb43a044cc.  Consumers of
wireless-testing, please make the necessary adjustment.

I apologize for the inconvenience...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
