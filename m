Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0045.hostedemail.com ([216.40.44.45]:40218 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756329AbaDHQOz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 12:14:55 -0400
Message-ID: <1396973691.5212.3.camel@joe-AO722> (sfid-20140408_181504_255919_9EEBEDA5)
Subject: Re: [PATCH 1/5] wil6210: Convert to Kbuild
From: Joe Perches <joe@perches.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	netdev <netdev@vger.kernel.org>
Date: Tue, 08 Apr 2014 09:14:51 -0700
In-Reply-To: <1396946179-11677-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1396946179-11677-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1396946179-11677-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-04-08 at 11:36 +0300, Vladimir Kondratiev wrote:
> Convert Makefile -> Kbuild,
> to make off-kernel development easier and less intrusive.

No drivers/net directory uses Kbuild.

Why should this?

> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/wil6210/Kbuild   | 18 ++++++++++++++++++
>  drivers/net/wireless/ath/wil6210/Makefile | 18 ------------------

If you send renaming patches, please use
git format-patch -M


