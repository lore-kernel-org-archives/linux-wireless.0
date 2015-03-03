Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43606 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbbCCNyn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 08:54:43 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	=?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH] ssb: Silence warning for unknown backplane revision
References: <1424290178-25328-1-git-send-email-Larry.Finger@lwfinger.net>
Date: Tue, 03 Mar 2015 15:54:37 +0200
In-Reply-To: <1424290178-25328-1-git-send-email-Larry.Finger@lwfinger.net>
	(Larry Finger's message of "Wed, 18 Feb 2015 14:09:38 -0600")
Message-ID: <87wq2y89uq.fsf@kamboji.qca.qualcomm.com> (sfid-20150303_145446_503896_E440E406)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> When using a BCM4318 in a PCMCIA format, I get a startup message that the
> device uses backplane revision 0xF000000. Next a WARNING is logged. Despite
> the message, the device works fine, This patch silences the warning.
>
> Cc: Rafał Miłecki <zajec5@gmail.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, applied to wireless-drivers-next.git.

-- 
Kalle Valo
