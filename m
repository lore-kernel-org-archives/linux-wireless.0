Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43691 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030192AbbKTJ3L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2015 04:29:11 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Jakub Kicinski <moorray3@wp.pl>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 23/27] rt2x00: move under ralink vendor directory
References: <1447857966-19560-1-git-send-email-kvalo@codeaurora.org>
	<1447857966-19560-24-git-send-email-kvalo@codeaurora.org>
	<20151119220522.24fa2733@laptop>
Date: Fri, 20 Nov 2015 11:29:04 +0200
In-Reply-To: <20151119220522.24fa2733@laptop> (Jakub Kicinski's message of
	"Thu, 19 Nov 2015 22:05:22 +0000")
Message-ID: <87twoht3xb.fsf@kamboji.qca.qualcomm.com> (sfid-20151120_102945_264284_A17AD391)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Kicinski <moorray3@wp.pl> writes:

> On Wed, 18 Nov 2015 16:46:02 +0200, Kalle Valo wrote:
>> Part of reorganising wireless drivers directory and Kconfig.
>> 
>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>
> For Ralink you could probably drop the rt2x00 directory.  RaLink Tech.
> doesn't exist any more and rt2x00 contains drivers for all of their
> devices.
>
> Obviously this is just a suggestion, not a show stopper.

Like I said with a similar comment to brcm80211 I would like to do that
separately. This is 27 patches already and I don't want make these any
more complicated than necessary.

-- 
Kalle Valo
