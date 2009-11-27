Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53696 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbZK0N35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2009 08:29:57 -0500
Received: by bwz27 with SMTP id 27so1171393bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2009 05:30:03 -0800 (PST)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/12] wl1251 WMM support and minor fixes
References: <20091126150141.917.35278.stgit@tikku>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 27 Nov 2009 15:30:01 +0200
In-Reply-To: <20091126150141.917.35278.stgit@tikku> (Kalle Valo's message of "Thu\, 26 Nov 2009 17\:08\:22 +0200")
Message-ID: <87ljhs859i.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@iki.fi> writes:

Hi John,

> here are few patches for wl1251. Now there is WMM support and also some
> minor fixes. The patchset applies on top of the wl1251 power save fixes I
> sent earlier today.

Please drop this patch set. I have to resend it again without patch 6
(the unnecessary unaligned memmove Johannes pointed out).

-- 
Kalle Valo
