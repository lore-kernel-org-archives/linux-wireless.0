Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:52488 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462Ab1JYMFw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 08:05:52 -0400
To: ilanelias78@gmail.com
Cc: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	samuel@sortiz.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: Re: [PATCH] NFC: update to NCI spec 1.0 draft 18
References: <1319355971-14757-1-git-send-email-ilane@ti.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 25 Oct 2011 15:05:48 +0300
In-Reply-To: <1319355971-14757-1-git-send-email-ilane@ti.com> (ilanelias's message of "Sun\, 23 Oct 2011 09\:46\:11 +0200")
Message-ID: <87sjmhb7j7.fsf@purkki.adurom.net> (sfid-20111025_140555_958815_B3A1FC87)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ilanelias78@gmail.com writes:

> From: Ilan Elias <ilane@ti.com>
>
> Signed-off-by: Ilan Elias <ilane@ti.com>
> ---
>  include/net/nfc/nci.h      |  208 ++++++++++++++++++++++---------------------
>  include/net/nfc/nci_core.h |   13 +--
>  net/nfc/nci/core.c         |   17 ++--
>  net/nfc/nci/data.c         |    5 +-
>  net/nfc/nci/lib.c          |    8 +--
>  net/nfc/nci/ntf.c          |  152 +++++++++++++++++++-------------
>  net/nfc/nci/rsp.c          |  149 ++++++++++++++-----------------
>  7 files changed, 281 insertions(+), 271 deletions(-)

That's quite a big patch having no commit log. You could at least
summarise what has been changed and impact of the changes.

-- 
Kalle Valo
