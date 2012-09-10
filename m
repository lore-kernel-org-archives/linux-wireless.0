Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63529 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab2IJSwI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 14:52:08 -0400
Received: by eaac11 with SMTP id c11so1075371eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Sep 2012 11:52:05 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v3.6] p54: fix off-by-one null pointer bug in p54_tx_80211
Date: Mon, 10 Sep 2012 20:51:57 +0200
Cc: linux-wireless@vger.kernel.org
References: <201209080128.43388.chunkeey@googlemail.com> <20120910184159.GC2137@tuxdriver.com>
In-Reply-To: <20120910184159.GC2137@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201209102051.57928.chunkeey@googlemail.com> (sfid-20120910_205212_382226_9ED8609B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 10 September 2012 20:42:00 John W. Linville wrote:
> This doesn't seem to apply on top of 3.6.  Is it OK to keep it
> for -next?  Or do you want to do a 3.6 version?
> 
Oh, isn't "move TX station pointer and restructure TX" in
3.6? Oh well, -next is ok in this case then :D.

Regards,
	Chr
