Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:14558 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab3HGH7s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 03:59:48 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl : Fix invalid pointer access on fuzz testing with AP mode
References: <1375678162-3190-1-git-send-email-mohammed@qca.qualcomm.com>
Date: Wed, 7 Aug 2013 10:59:40 +0300
In-Reply-To: <1375678162-3190-1-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Mon, 5 Aug 2013 10:19:22
	+0530")
Message-ID: <87wqny53tf.fsf@kamboji.qca.qualcomm.com> (sfid-20130807_095952_040284_257F97D6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:

> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>
> In our Fuz testing, reference client corrupts the dest mac to "00:00:00:00:00:00"
> in the WPA2 handshake no 2. During driver init the sta_list entries mac
> addresses are by default "00:00:00:00:00:00". Driver returns an invalid
> pointer (conn) and the drver shall crash, if rxtids (aggr_conn)
> skb queues are accessed, since they would not be initialized.
>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Thanks, applied.

I just did s/ath6kl :/ath6kl:/ in the subject.

-- 
Kalle Valo
