Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58735 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab1HXSpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 14:45:14 -0400
Date: Wed, 24 Aug 2011 14:31:28 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [RFC][PATCH V2] b43: drop Kconfig option of forcing PIO mode
Message-ID: <20110824183128.GJ9770@tuxdriver.com> (sfid-20110824_204520_757466_5C5FB35E)
References: <1313489647-8979-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1313489647-8979-1-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 16, 2011 at 12:14:07PM +0200, Rafał Miłecki wrote:
> We have module param called use_pio which is much easier to use.
> 
> Cc: Larry Finger <larry.finger@lwfinger.net>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> V2: include b43.h change
> 
> Larry introduced use_pio with:
>     b43: Allow PIO mode to be selected at module load
> I believe we can leave this simple module param and drop
> CONFIG_B43_FORCE_PIO instead.

Seems reasonable to me...any objections?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
