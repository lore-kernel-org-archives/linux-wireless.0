Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4593 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756317AbYB0Sif (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 13:38:35 -0500
Date: Wed, 27 Feb 2008 13:26:13 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>, jt@hpl.hp.com
Subject: Re: linux/wireless.h - missing section
Message-ID: <20080227182613.GE3078@tuxdriver.com> (sfid-20080227_183929_088292_977070A3)
References: <1ba2fa240802270940te95e776n4958ff6b9f5beb20@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240802270940te95e776n4958ff6b9f5beb20@mail.gmail.com>
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

Those were in Jean's original WE-21 patch.  They got
dropped in the redacted version of WE-21 I applied in commit
baef186519c69b11cf7e48c26e75feb1e6173baa.  Please see these threads:

	http://marc.info/?l=linux-netdev&m=115689985827349&w=2
	http://marc.info/?l=linux-netdev&m=115757728300747&w=2

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com
