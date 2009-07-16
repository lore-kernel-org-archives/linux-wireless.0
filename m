Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:41358 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbZGPQa0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 12:30:26 -0400
Received: by qyk30 with SMTP id 30so215086qyk.33
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 09:30:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907161108.57436.helmut.schaa@gmail.com>
References: <200907161104.41975.helmut.schaa@gmail.com> <200907161108.57436.helmut.schaa@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 16 Jul 2009 09:30:04 -0700
Message-ID: <43e72e890907160930ra5111e1qac13701aed15974e@mail.gmail.com>
Subject: Re: [RFC/RFT 4/5] mac80211: Replace {sw,hw}_scanning variables with a
	bitfield
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 16, 2009 at 2:08 AM, Helmut
Schaa<helmut.schaa@googlemail.com> wrote:
> Use a bitfield to store the current scan mode instead of two boolean
> variables {sw,hw}_scanning. This patch does not introduce functional
> changes.
>

> +enum mac80211_scan_flag {
> +       SCAN_SW_SCANNING = 1,
> +       SCAN_HW_SCANNING = 2,
> +};
> +

But why is that needed? The commit log doesn't state that. We won't
use both at the same time.

  Luis
