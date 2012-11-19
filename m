Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34310 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2KSWcJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 17:32:09 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so3787172pbc.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 14:32:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353361141.18299.36.camel@jlt4.sipsolutions.net>
References: <1352832488-21516-1-git-send-email-thomas@cozybit.com>
	<1353361141.18299.36.camel@jlt4.sipsolutions.net>
Date: Mon, 19 Nov 2012 14:32:08 -0800
Message-ID: <CAJ-VmomL6g1LfTNsk6HPeKEySS57-646L6i9rcOT0V9cDK0b9w@mail.gmail.com> (sfid-20121119_233213_038897_5C162C17)
Subject: Re: [PATCH v2 1/2] ath9k: RX timestamp is reported at end of frame
From: Adrian Chadd <adrian@freebsd.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <thomas@cozybit.com>, ath9k-devel@lists.ath9k.org,
	mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 November 2012 13:39, Johannes Berg <johannes@sipsolutions.net> wrote:

> Before you repost though I think it would make sense to fix the
> calculation issue that Simon pointed out on the radiotap list? I hope he
> comes up with some code though as I'm not good enough at bitrate
> calculations :-)

What was his comment?



Adrian
