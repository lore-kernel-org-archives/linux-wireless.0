Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42446 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751376AbdJPKv5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 06:51:57 -0400
Date: Mon, 16 Oct 2017 12:51:55 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-wireless@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: rc2-next-20170929: wireless down, won't come up
Message-ID: <20171016105154.GB3752@redhat.com> (sfid-20171016_125212_122557_9E850817)
References: <20171016091830.GA21812@amd>
 <20171016102745.GA22525@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171016102745.GA22525@amd>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

Site note: Intel folks do not support iwlegacy, I removed them from CC.

On Mon, Oct 16, 2017 at 12:27:45PM +0200, Pavel Machek wrote:
> > In -next... after few days of usage with suspend and resume cycles,
> > wifi failed on thinkpad x60. I have not seen this in years...
<snip>
> > Any ideas?

We do not have any recent iwlegacy changes except cosmetic
ones, so this problem most likely is mac80211, pci or other
subsystem issue

> Suspend+resume fixed the problem.

It is not reproducible? If so, I think it will not be 
easy to identify the issue.

Thanks
Stanislaw
