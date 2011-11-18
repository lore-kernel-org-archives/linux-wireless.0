Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:7269 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756392Ab1KRW6b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 17:58:31 -0500
Date: Fri, 18 Nov 2011 17:58:28 -0500
From: Pavel Roskin <proski@gnu.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 41/77] iwlegacy: s/STATUS_/S_/
Message-ID: <20111118175828.6e94d02e@mj> (sfid-20111118_235834_275260_3B940CA1)
In-Reply-To: <1321604559-10707-41-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
	<1321604559-10707-41-git-send-email-sgruszka@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 18 Nov 2011 09:22:03 +0100
Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

I think this particular change would make the code less readable.  It's
one thing to replace TABLE with TBL, but S_ can be anything - signed,
special, settable, stable...

> -		set_bit(STATUS_RF_KILL_HW, &il->status);
> +		set_bit(S_RF_KILL_HW, &il->status);

You may want to replace RF_KILL with RFKILL if you are desperate to
shorten variable names.

-- 
Regards,
Pavel Roskin
