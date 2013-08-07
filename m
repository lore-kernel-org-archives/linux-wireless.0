Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:42093 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352Ab3HGRUC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 13:20:02 -0400
Received: by mail-lb0-f173.google.com with SMTP id 10so1720591lbf.32
        for <linux-wireless@vger.kernel.org>; Wed, 07 Aug 2013 10:20:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
References: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 7 Aug 2013 10:19:40 -0700
Message-ID: <CAB=NE6XSQOtMzhB6Q_CmjT5aA+=hKvVU3m8yT33=bcE7sEBOFQ@mail.gmail.com> (sfid-20130807_192008_159792_B41E40D8)
Subject: Re: [RFC 00/53] wireless-regdb: mostly VHT80 updates
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 3, 2013 at 6:03 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>
> Here's a series of updates for wireless-regdb. Most of this is
> to just enable VHT80 support to enable support for 802.11ac
> where this has been verified to be usable. I cannot meet the
> criteria of providing full documentation for sources for all
> patches, only a few ones so what I recommend for the rest is
> to let this sit on the list for a bit and I'd hope after
> review if no one spots any issues I'd hope we can merge this.
>
> I reviewed the idea of vendor namespaces on wireless-regdb
> and at least through review with pkgadd on IRC we concluded
> its best to try to take this approach instead of encouraging
> divergence due to any lack of full source documentation or
> inability to provide such documentation for whatever reason.
> This seems to be better than not getting any updates at all
> and keeps vendors hopefully encouraged to push changes upstream.

John,

I addressed all comments and its been a while without any negative
feedback on the patches. If you do decide to merge I put the delta on
this tree to make it easy to pull, on the master branch.

git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/wireless-regdb.git

  Luis
