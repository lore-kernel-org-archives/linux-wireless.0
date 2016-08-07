Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33859 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbcHGHYo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Aug 2016 03:24:44 -0400
Received: by mail-pa0-f53.google.com with SMTP id fi15so104637347pac.1
        for <linux-wireless@vger.kernel.org>; Sun, 07 Aug 2016 00:24:44 -0700 (PDT)
Date: Sun, 07 Aug 2016 00:24:38 -0700 (PDT)
Message-Id: <20160807.002438.1914925161653123293.davem@davemloft.net> (sfid-20160807_092455_183632_FC9A5EF4)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2016-08-05
From: David Miller <davem@davemloft.net>
In-Reply-To: <1470400329-23256-1-git-send-email-johannes@sipsolutions.net>
References: <1470400329-23256-1-git-send-email-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri,  5 Aug 2016 14:32:08 +0200

> Here's a first set of fixes for the current cycle. See the tag message
> for more information.
> 
> I'll probably have a follow-up fix for the real problem in mac80211
> that caused the crash later, but for now we have this patch and it
> makes sense and fixes the crash, even if the behaviour isn't quite
> right (afaict.)
> 
> Let me know if there's any problem.

Pulled, thanks.
