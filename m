Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34322 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbbGEKfY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2015 06:35:24 -0400
Message-ID: <1436092516.6268.1.camel@sipsolutions.net> (sfid-20150705_123527_008133_DDDCAC60)
Subject: Re: [PATCH 02/13] wil6210: ACS implementation using QCA vendor
 command
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Vladimir Shulman <QCA_shulmanv@QCA.qualcomm.com>
Date: Sun, 05 Jul 2015 12:35:16 +0200
In-Reply-To: <1436081080-27305-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150705_104616_458904_BCE594A3)
References: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1436081080-27305-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 (sfid-20150705_104616_458904_BCE594A3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-07-05 at 10:24 +0300, Vladimir Kondratiev wrote:
> ACS is implemented by registering to QCA vendor ACS sub command.
> On receive of the command from hostapd, driver issues passive
> scan command and block until scan results are available.
> When received, the results are sent up using QCA vendor ACS
> results event
> 
I'm not convinced that we really want vendor commands upstream in the
kernel. There at least we could go the extra mile to make proper non
-vendor APIs, no?

johannes
