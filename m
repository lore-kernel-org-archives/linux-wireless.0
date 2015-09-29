Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37042 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbbI2H7p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 03:59:45 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: bcma: add support for population subnodes also when build as
 module
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1442666630-19087-1-git-send-email-hauke@hauke-m.de>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Message-Id: <20150929075944.A220F140FAA@smtp.codeaurora.org> (sfid-20150929_095948_154185_44104043)
Date: Tue, 29 Sep 2015 07:59:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> of_default_bus_match_table was not exported earlier, so it could only
> be accessed by code compiled into the kernel. A new function
> of_platform_default_populate() was added which uses
> of_default_bus_match_table and this function is also exported. This way
> it is possible to create a bus with the content of
> of_default_bus_match_table and we can remove the hacks from bcma.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
