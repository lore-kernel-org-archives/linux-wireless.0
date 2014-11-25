Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbaKYOBQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 09:01:16 -0500
Date: Tue, 25 Nov 2014 14:57:45 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ronald Wahl <ronald.wahl@raritan.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Mike Romberg <mike-romberg@comcast.net>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2800: fix RT5592 TX power settings
 regression
Message-ID: <20141125135744.GA2032@redhat.com> (sfid-20141125_150121_137484_D86FA5B4)
References: <1415207010-9622-1-git-send-email-ronald.wahl@raritan.com>
 <20141106102753.GA1891@redhat.com>
 <20141120210859.GE31881@tuxdriver.com>
 <546F085B.3060408@raritan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <546F085B.3060408@raritan.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 21, 2014 at 10:39:39AM +0100, Ronald Wahl wrote:
> For me the patch will work but there is a change for RT3290 and RT5390. On
> both chipsets BBP 1 was not written before but with this patch it is going
> to be written now and the value depends on the return of
> rt2800_get_txpower_bw_comp(). It should be checked that the function does
> the correct things for these chips.

I tested the patch on RT5390, it does not make troubles. Going to post
it ...

Stanislaw

