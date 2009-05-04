Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:2650 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbZEDSiT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 14:38:19 -0400
MIME-Version: 1.0
In-Reply-To: <1241453096-8517-1-git-send-email-jirislaby@gmail.com>
References: <1241453096-8517-1-git-send-email-jirislaby@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 4 May 2009 11:38:04 -0700
Message-ID: <43e72e890905041138q4bf43405u7fca133dac991dc4@mail.gmail.com>
Subject: Re: [PATCH 1/2] mac80211: minstrel, fix memory corruption
To: Jiri Slaby <jirislaby@gmail.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 4, 2009 at 9:04 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> minstrel doesn't count max rate count in fact, since it doesn't use
> a loop variable `i' and hence allocs space only for bitrates found in
> the first band.
>
> Fix it by involving the `i' as an index so that it traverses all the
> bands now and finds the real max bitrate count.
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Felix Fietkau <nbd@openwrt.org>

Cc: stable@kernel.org

  Luis
