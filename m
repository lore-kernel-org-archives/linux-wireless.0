Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:49303 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbYJWCnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 22:43:00 -0400
Received: by gxk9 with SMTP id 9so607336gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 19:42:59 -0700 (PDT)
Message-ID: <43e72e890810221942w398fd7aco3042ee5456453ec1@mail.gmail.com> (sfid-20081023_044306_278117_822D4096)
Date: Wed, 22 Oct 2008 19:42:59 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Power saving on mac80211
Cc: "Zhu Yi" <yi.zhu@intel.com>
In-Reply-To: <43e72e890810171810t1c65642g998db601cfe2a390@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890810171810t1c65642g998db601cfe2a390@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 17, 2008 at 6:10 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:

>  * What do we have to do, if anything at all, for PCI Express (PCIe)
> Active State Power Management (ASPM)?

Just FYI

I digged into this. Technically speaking we don't have to do anything
for this so long as the kernel supports it and we did get the support
as of 2.6.26. Its still marked as experimental and won't get this
removed until it gets more exposure. When enabled some devices may
encounter *interesting* issues and because of this some drivers may
have a few routines / checks / do things a bit differently when
enabled. See e1000 as an example.

  Luis
