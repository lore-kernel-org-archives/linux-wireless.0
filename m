Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:47503 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933562Ab3GWSVi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jul 2013 14:21:38 -0400
Received: by mail-la0-f54.google.com with SMTP id ec20so6395749lab.41
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jul 2013 11:21:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1374413809-26005-1-git-send-email-arik@wizery.com>
References: <1374413809-26005-1-git-send-email-arik@wizery.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 23 Jul 2013 11:21:16 -0700
Message-ID: <CAB=NE6Wk=-c5yhWEt4Tr760HpDcZCezc1ToE0Tkh4UM3DPLTVg@mail.gmail.com> (sfid-20130723_202141_322440_B9D0DA70)
Subject: Re: [PATCH 1/2] regulatory: use correct regulatory initiator on wiphy register
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 21, 2013 at 6:36 AM, Arik Nemtsov <arik@wizery.com> wrote:
> The current regdomain was not always set by the core. This causes
> cards with a custom regulatory domain to ignore user initiated changes
> if done before the card was registered.
>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

  Luis
