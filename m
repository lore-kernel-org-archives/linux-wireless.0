Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:45525 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755109Ab0HMMdH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Aug 2010 08:33:07 -0400
To: ext-yuri.kululin@nokia.com
Cc: linux-wireless@vger.kernel.org, ameya.palande@nokia.com
Subject: Re: [PATCH 1/1] wl1251: fix trigger scan timeout usage
References: <8ca8a9b93496d16bc8b5956c3a7976c08b95282c.1281691901.git.ext-yuri.kululin@nokia.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Fri, 13 Aug 2010 15:33:05 +0300
In-Reply-To: <8ca8a9b93496d16bc8b5956c3a7976c08b95282c.1281691901.git.ext-yuri.kululin@nokia.com> (ext-yuri kululin's message of "Fri\, 13 Aug 2010 13\:46\:12 +0400")
Message-ID: <87bp96bsla.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext-yuri.kululin@nokia.com writes:

> From: Yuri Kululin <ext-yuri.kululin@nokia.com>
>
> Use appropriate command (CMD_TRIGGER_SCAN_TO) instead of scan command
> (CMD_SCAN) to configure trigger scan timeout.
>
> This was broken in commit 3a98c30f3e8bb1f32b5bcb74a39647b3670de275.

Good find. I broke this last January, sorry about that. 

John, the patch fixes this bug:

https://bugzilla.kernel.org/show_bug.cgi?id=16554

If possible, try to get this to 2.6.36. Otherwise wl1251 is more or
less broken. I'll make sure that this goes to stable releases as well.

> Cc: stable@kernel.org
> Signed-off-by: Yuri Ershov <ext-yuri.ershov@nokia.com>
> Signed-off-by: Yuri Kululin <ext-yuri.kululin@nokia.com>

Acked-by: Kalle Valo <kvalo@adurom.com>

Thanks.

-- 
Kalle Valo
