Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52398 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab2FRHRh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 03:17:37 -0400
Received: by bkcji2 with SMTP id ji2so3711906bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 00:17:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338971102-4872-1-git-send-email-arik@wizery.com>
References: <1338971102-4872-1-git-send-email-arik@wizery.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 18 Jun 2012 10:17:19 +0300
Message-ID: <CA+XVXfdWCX-M01UeixuGPh-hb1coL1DcHfj_1JKJ3Purgm16aQ@mail.gmail.com> (sfid-20120618_091740_609437_8DCE5003)
Subject: Re: [PATCH v3] mac80211: stop Rx during HW reconfig
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 6, 2012 at 11:25 AM, Arik Nemtsov <arik@wizery.com> wrote:
> While HW reconfig is in progress, drop all incoming Rx. This prevents
> incoming packets from changing the internal state of the driver or
> calling callbacks of the low level driver while it is in inconsistent
> state.
>

Ping?
