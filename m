Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36005 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1KAGIs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Nov 2011 02:08:48 -0400
Message-ID: <4EAF8C52.90105@qca.qualcomm.com> (sfid-20111101_070852_086917_C9ADE700)
Date: Tue, 1 Nov 2011 08:06:10 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/5] ath6kl: cut power when interface is down
References: <20111030190922.20466.299.stgit@localhost6.localdomain6>
In-Reply-To: <20111030190922.20466.299.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/30/2011 09:15 PM, Kalle Valo wrote:
> The following series changes interface handling so that power is
> cut from the chip whenever interface is down compared to the current
> situation when the harware is powered all the time since module
> is loaded.
> 
> I'm not really sure if this is going be the final implementation
> but I'll send this for review anyway. I structured the code so that
> it's easy to go back to the old functionality if we so desire.
> 
> Also I need to solve support for multivif. Currently these patches
> work as there's only one vif.

Applied all five.

Kalle
