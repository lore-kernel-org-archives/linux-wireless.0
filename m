Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbYGaNzM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 09:55:12 -0400
Subject: Re: [patch 4/4] wireless: replace __FUNCTION__ with __func__
From: Dan Williams <dcbw@redhat.com>
To: akpm@linux-foundation.org
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	harvey.harrison@gmail.com
In-Reply-To: <200807301946.m6UJkMGK012997@imap1.linux-foundation.org>
References: <200807301946.m6UJkMGK012997@imap1.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 09:52:15 -0400
Message-Id: <1217512335.12016.4.camel@localhost.localdomain> (sfid-20080731_155515_239698_81F0509D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-07-30 at 12:46 -0700, akpm@linux-foundation.org wrote:
> From: Harvey Harrison <harvey.harrison@gmail.com>
> 
> __FUNCTION__ is gcc-specific, use __func__
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/net/wireless/airo.c                   |   16 ++++++++--------

Acked-by: Dan Williams <dcbw@redhat.com>

>  drivers/net/wireless/libertas/if_cs.c         |    2 +-

Acked-by: Dan Williams <dcbw@redhat.com>

>  drivers/net/wireless/prism54/isl_ioctl.c      |    8 ++++----

Acked-by: Dan Williams <dcbw@redhat.com>


