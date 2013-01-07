Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:61630 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab3AGSx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 13:53:56 -0500
Received: by mail-wg0-f53.google.com with SMTP id fn15so2397819wgb.8
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2013 10:53:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1357571093-12868-3-git-send-email-marco@cozybit.com>
References: <1357571093-12868-1-git-send-email-marco@cozybit.com> <1357571093-12868-3-git-send-email-marco@cozybit.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 7 Jan 2013 10:47:34 -0800
Message-ID: <CAG6hwVMSJaDu=agc+f3F5RtAjmVwBqCTuDgBOo0saZ7C4KtWHw@mail.gmail.com> (sfid-20130107_195400_182089_5FF4BE59)
Subject: Re: [PATCHv2 2/6] mac80211: update mesh peer link counter during
 userspace peering
To: devel@lists.open80211s.org
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 7, 2013 at 7:04 AM, Marco Porsch <marco@cozybit.com> wrote:
> The established peer link count is indicated in mesh beacons and used for
> other internal tasks. Previously it was not updated when authenticated peering
> is performed in userspace.
>
> Signed-off-by: Marco Porsch <marco@cozybit.com>
Acked-by: Thomas Pedersen <thomas@cozybit.com>
