Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:43042 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754122Ab1EBJvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2011 05:51:03 -0400
Received: by mail-ew0-f47.google.com with SMTP id 5so1672990ewy.6
        for <linux-wireless@vger.kernel.org>; Mon, 02 May 2011 02:51:01 -0700 (PDT)
Subject: Re: [PATCH v2] wl12xx: support FW TX inactivity triggers
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTinnQgZGjZOigQuUSVD0kCBTuzUE1A@mail.gmail.com>
References: <1303849311-8817-1-git-send-email-arik@wizery.com>
	 <BANLkTi=mJE+M79-XOJsTPRu1zGodiiZ8bg@mail.gmail.com>
	 <BANLkTinnQgZGjZOigQuUSVD0kCBTuzUE1A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 May 2011 12:50:55 +0300
Message-ID: <1304329855.12586.234.camel@cumari> (sfid-20110502_115107_585989_1F7E51DA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John and Arik,

On Sat, 2011-04-30 at 00:09 +0300, Arik Nemtsov wrote:
> Hey John,
> 
> Looking at the latest git, it seems you've picked up this patch
> (commit 47684808fd89d6809c0886e06f8ac324252499d8).
> This is unfortunate, since there's currently a FW bug that will cause
> many disconnections in STA mode with this patch.
> 
> How would we go about reverting this?

I have reverted this patch in the wl12xx.git tree.  This required a bit
of merging and we needed the revert in order to proceed with our tests.

So, John, please don't revert this in your tree.  My revert will come in
my next pull-request which will come in a couple of days, after our
internal test round is done.

Thanks!

-- 
Cheers,
Luca.

