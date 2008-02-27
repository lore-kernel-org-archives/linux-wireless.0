Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:55628 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbYB0SFz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 13:05:55 -0500
Date: Wed, 27 Feb 2008 09:46:20 -0800
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: linux/wireless.h - missing section
Message-ID: <20080227174619.GA25139@bougret.hpl.hp.com> (sfid-20080227_180609_299257_D50FC308)
Reply-To: jt@hpl.hp.com
References: <1ba2fa240802270940te95e776n4958ff6b9f5beb20@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240802270940te95e776n4958ff6b9f5beb20@mail.gmail.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 27, 2008 at 07:40:07PM +0200, Tomas Winkler wrote:
> Does anybody knows why this section is missing from in kernel linux/wireless.h
> 
> struct iw_range {
> 
> ......
> 
> 
>         /* More power management stuff */
>         __s32           min_pms;        /* Minimal PM saving */
>         __s32           max_pms;        /* Maximal PM saving */
>         __u16           pms_flags;      /* How to decode max/min PM saving */
> 
>         /* All available modulations for driver (hw may support less) */
>         __s32           modul_capa;     /* IW_MODUL_* bit field */
> 
>         /* More bitrate stuff */
>         __u32           bitrate_capa;   /* Types of bitrates supported */
> };
> 
> Thanks
> Tomas

	Because it was rejected by the kernel maitainers.

	Jean
