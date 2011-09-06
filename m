Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26760 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab1IFICk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 04:02:40 -0400
To: Vivek Natarajan <nataraja@qca.qualcomm.com>
Message-ID: <4E65D399.6020904@qca.qualcomm.com> (sfid-20110906_100245_709531_E9446585)
Date: Tue, 6 Sep 2011 11:02:33 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath6kl: Process regulatory requests from firmware.
References: <1315294296-3712-1-git-send-email-vivek.natarajan@qca.qualcomm.com>
In-Reply-To: <1315294296-3712-1-git-send-email-vivek.natarajan@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/06/2011 10:31 AM, Vivek Natarajan wrote:
> From: Vivek Natarajan <nataraja@qca.qualcomm.com>
> 
> Process the regulatory code from eeprom and pass the
> country information to cfg80211.

Thanks, applied. I did a minor white space change which I missed in my
original review:

commit 060337604577e55c5bf3246bcaf161929c603d54
Author: Vivek Natarajan <nataraja@qca.qualcomm.com>
Date:   Tue Sep 6 13:01:36 2011 +0530

    ath6kl: Process regulatory requests from firmware.

    Process the regulatory code from eeprom and pass the
    country information to cfg80211.

    kvalo: add space between struct name and *

    Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Kalle
