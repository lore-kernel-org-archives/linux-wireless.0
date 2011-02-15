Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38315 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab1BORht (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 12:37:49 -0500
Received: by bwz15 with SMTP id 15so670855bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 09:37:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297771723.3935.4.camel@jlt3.sipsolutions.net>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
	<1297619803-2832-3-git-send-email-njs@pobox.com>
	<1297685761.3785.38.camel@jlt3.sipsolutions.net>
	<AANLkTikmsizzK1J=uf4Rp9fkmDdJQ_oKfZV-jUz2sJ18@mail.gmail.com>
	<1297771723.3935.4.camel@jlt3.sipsolutions.net>
Date: Tue, 15 Feb 2011 09:37:47 -0800
Message-ID: <AANLkTi=m6y0_7z=7P4yUHvGMqiRj=fSRmwYAjuqo_-rt@mail.gmail.com>
Subject: Re: [PATCH 2/5] iwlwifi: Convert the tx queue high_mark to an atomic_t
From: Nathaniel Smith <njs@pobox.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	wey-yi.w.guy@intel.com, ilw@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 15, 2011 at 4:08 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Actually, it doesn't really matter. Linux assumes that reads and writes
> to "unsigned long" are always atomic against each other (i.e. you get
> either the old or the new value) and that's all you care about here --
> this never needs anything like atomic_inc/dec etc.

Excellent point, thank you.

-- Nathaniel
