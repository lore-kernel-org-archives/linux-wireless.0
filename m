Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:36216 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbbAIAbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2015 19:31:55 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21679.8708.380907.499061@gargle.gargle.HOWL> (sfid-20150109_013159_201268_AECDE496)
Date: Fri, 9 Jan 2015 06:04:12 +0530
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	<ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH] ath: ath9k: use debugfs_create_devm_seqfile() helper
 for seq_file entries
In-Reply-To: <54AEE430.2070706@broadcom.com>
References: <1419685980-4728-1-git-send-email-arend@broadcom.com>
	<87bnmapiur.fsf@kamboji.qca.qualcomm.com>
	<21677.63268.657151.679992@gargle.gargle.HOWL>
	<54AEE430.2070706@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel wrote:
> So the content of the modified debugfs files looks sane?

Yep, as sane as the code populating the debug data. :-)

Sujith
