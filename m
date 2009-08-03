Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:53776 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbZHCVGj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 17:06:39 -0400
MIME-Version: 1.0
In-Reply-To: <20090803205954.GE11441@tuxdriver.com>
References: <20090803205954.GE11441@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 3 Aug 2009 14:06:19 -0700
Message-ID: <43e72e890908031406u1e15f074h173e4806daab343f@mail.gmail.com>
Subject: Re: pull request: wireless-2.6 2009-08-03
To: "John W. Linville" <linville@tuxdriver.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 3, 2009 at 1:59 PM, John W. Linville<linville@tuxdriver.com> wrote:
> Dave,
>
> Here is another round of fixes intended for 2.6.31.  The one from
> Reinette fixes an rfkill-related bug described in bugzilla 13742.  The one
> from Luis has a lengthy changelog, but boils down to correcting some
> regulatory enforcement issues that would prevent some devices from
> working in some localities.  The rest are simple and obvious.
>
> Please let me know if there are problems!
>
> Thanks,
>
> John
>
> ---
>
> Individual patches are available here:
>
>        http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/

John, just noticed the patches in this link do not correspond.

  Luis
