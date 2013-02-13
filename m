Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:32873 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965133Ab3BMXL7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 18:11:59 -0500
Received: by mail-bk0-f54.google.com with SMTP id w5so811569bku.13
        for <linux-wireless@vger.kernel.org>; Wed, 13 Feb 2013 15:11:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1360795927.8868.30.camel@jlt4.sipsolutions.net>
References: <1360786461-30107-1-git-send-email-thomas@cozybit.com> <1360795927.8868.30.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Wed, 13 Feb 2013 15:11:36 -0800
Message-ID: <CAG6hwVMKj5JKpRWgJ3x0_+DsQ13AiXhC6G18RM9OUUrX1UQypA@mail.gmail.com> (sfid-20130214_001202_651947_CC0A85ED)
Subject: Re: [PATCH v2 1/3] mac80211: consolidate MBSS change notification
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 13, 2013 at 2:52 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Applied all, removing the useless "return" in patch 2 and also adding a
> proper return value there if beacon allocation fails.

Great, thanks for the review.

-- 
Thomas
