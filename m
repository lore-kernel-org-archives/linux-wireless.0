Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:57219 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbZKIW6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 17:58:42 -0500
Received: by iwn10 with SMTP id 10so2801414iwn.4
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 14:58:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1257805260-13265-1-git-send-email-hauke@hauke-m.de>
References: <1257805260-13265-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 9 Nov 2009 14:58:28 -0800
Message-ID: <43e72e890911091458n9d1b2aew1977034c874fc68f@mail.gmail.com>
Subject: Re: [PATCH 0/4] [compat-2.6] Some patches for compat-wireless
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 9, 2009 at 2:20 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Some patches for compat-wireless
> For kernel 2.6.26 and older debugfs_remove_recursive needs to be
> backported. The problems with rt2800lib will be fixed in
> wireless-testing.
>
> v2: resend patches because of line-wrap.

Applied thanks. BTW git apply still did not like these patches due to
the tab after From:, it seems git likes no tab there but just a space.

  Luis

[1] http://wireless.kernel.org/en/developers/Documentation/git-guide
