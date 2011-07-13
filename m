Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12010 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965080Ab1GMIe1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 04:34:27 -0400
Message-ID: <4E1D588D.40700@qca.qualcomm.com> (sfid-20110713_103430_732016_FC631D6D)
Date: Wed, 13 Jul 2011 11:34:21 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <devel@linuxdriverproject.org>,
	<gregkh@suse.de>, <error27@gmail.com>
Subject: Re: [PATCH 00/24] ath6kl cleaned up driver
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
In-Reply-To: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/13/2011 04:32 AM, Kalle Valo wrote:
> Hello,
> 
> last May we started working on cleaning up ath6kl driver which is
> currently in staging. The work has happened in a separate
> ath6kl-cleanup tree:
> 
> http://git.kernel.org/?p=linux/kernel/git/kvalo/ath6kl-cleanup.git;a=summary
> 
> After over 1100 (!) patches we have now reached a state where I would
> like to start discussing about pushing the driver to the wireless
> trees and replacing the staging driver.

[...]

> I'm sending the patch in multiple emails, one file per message, to
> make it easier to review. During the final inclusion I can send the
> driver as one patch (if that's preferred).

If someone prefers to have the combined patch, it's available here:

http://www.kernel.org/pub/linux/kernel/people/kvalo/ath6kl/ath6kl-201107130415.patch

Kalle
