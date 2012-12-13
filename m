Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64233 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab2LMWIA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 17:08:00 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so2246444lbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 14:07:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354812468-15709-24-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net> <1354812468-15709-24-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 13 Dec 2012 14:07:39 -0800
Message-ID: <CAB=NE6Vi6WzTzdafqba1zv0GMptvsdKjSspNAw++9WaPXe_66w@mail.gmail.com> (sfid-20121213_230807_833327_1826CCF6)
Subject: Re: [PATCH 23/24] regulatory: use RCU to protect last_request
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 8:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> This will allow making freq_reg_info() lock-free.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

Neat!

  Luis
