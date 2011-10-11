Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34824 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab1JKLYk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 07:24:40 -0400
To: Kevin Fang <chienf@qca.qualcomm.com>
Message-ID: <4E942773.6040302@qca.qualcomm.com> (sfid-20111011_132444_341769_EE0B6AC9)
Date: Tue, 11 Oct 2011 14:24:35 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/1] ath6kl: Add WSC IE on the associate message
References: <Y> <1317948679-10299-1-git-send-email-kevin.fang@qca.qualcomm.com>
In-Reply-To: <1317948679-10299-1-git-send-email-kevin.fang@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/07/2011 03:51 AM, Kevin Fang wrote:
> For some WPS test items, such as item "5.1.14"
> STAUT must include the WSC IE in the 802.11 Association Request frame.
> Therefore, add the corresponding IE in association message.

Applied, thanks!

Kalle
