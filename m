Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:43708 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbZC3EiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 00:38:25 -0400
Received: by bwz17 with SMTP id 17so1737923bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 29 Mar 2009 21:38:22 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@web.de>
Subject: Re: p54spi - mesh mode summary
Date: Mon, 30 Mar 2009 07:38:11 +0300
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <1237959016-17311-1-git-send-email-jcmvbkbc@gmail.com> <200903290841.59902.jcmvbkbc@gmail.com> <200903291549.17216.chunkeey@web.de>
In-Reply-To: <200903291549.17216.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903300838.12003.jcmvbkbc@gmail.com> (sfid-20090330_063828_452283_66098103)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> hmm, sta_unlock is called from a tasklet, so we must use the irqsave
> functions does this warning go away with the attached patch?
Yes, it does.

-- 
Thanks.
-- Max
