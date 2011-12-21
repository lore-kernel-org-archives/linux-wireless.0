Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38620 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab1LUPPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 10:15:35 -0500
Subject: Re: [PATCH 5/6] ath5k: avoid sparse warnings on tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1324406771-7100-6-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20111220_194823_067219_205CF66E)
References: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com>
	 <1324406771-7100-6-git-send-email-rodrigue@qca.qualcomm.com>
	 (sfid-20111220_194823_067219_205CF66E)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Dec 2011 16:15:29 +0100
Message-ID: <1324480529.3401.8.camel@jlt3.sipsolutions.net> (sfid-20111221_161539_452341_81617AF7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-12-20 at 10:46 -0800, Luis R. Rodriguez wrote:

> Just skip the sparse checks on tracing.

I seem to remember removing that elsewhere since newer sparse or newer
tracing code worked fine together.

johannes

