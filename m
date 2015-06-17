Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:38044 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbbFQKR7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 06:17:59 -0400
Received: by igblz2 with SMTP id lz2so33269037igb.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2015 03:17:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1434532138.1884.22.camel@sipsolutions.net>
References: <1434056692-8011-1-git-send-email-chaitanya.mgit@gmail.com> <1434532138.1884.22.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 17 Jun 2015 15:47:38 +0530
Message-ID: <CABPxzYKoVruvBuzwPLmVcG2Aemhgmo+zbR3rPkLg-WRqswpG9w@mail.gmail.com> (sfid-20150617_121803_261376_0F41EB59)
Subject: Re: [PATCH V4] mac80211: minstrel_ht: Handle Dynamic SMPS state of
 the peer.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 17, 2015 at 2:38 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2015-06-12 at 02:34 +0530, Chaitanya T K wrote:
>> In case of Dynamic SMPS enable RTS/CTS for all rates.
>
> Applied. I really think you should drop the "." at the end of the
> subject though :)
>
Oh..will drop it. Is there any special reason?
