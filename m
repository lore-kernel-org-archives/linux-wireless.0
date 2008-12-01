Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f18.google.com ([209.85.217.18]:43533 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbYLATCY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 14:02:24 -0500
Received: by gxk11 with SMTP id 11so57100gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 11:02:09 -0800 (PST)
Message-ID: <43e72e890812011101r3ad8225aofafdada8b5699535@mail.gmail.com> (sfid-20081201_200228_937457_A9917803)
Date: Mon, 1 Dec 2008 11:01:52 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: fix wiphy remove if no regulatory request
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1228129676.3478.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1228129676.3478.0.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 1, 2008 at 3:07 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Fixes the segfault I just pointed out.

Thanks, the commit log should include the panic I guess though right?

  Luis
