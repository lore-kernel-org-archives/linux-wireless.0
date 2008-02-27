Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:9633 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153AbYB0TXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 14:23:24 -0500
Received: by wa-out-1112.google.com with SMTP id v27so3411244wah.23
        for <linux-wireless@vger.kernel.org>; Wed, 27 Feb 2008 11:23:24 -0800 (PST)
Message-ID: <1ba2fa240802271123v1cbaf0ael9c01508b47a817b4@mail.gmail.com> (sfid-20080227_192328_957082_AB32C97F)
Date: Wed, 27 Feb 2008 21:23:20 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: linux/wireless.h - missing section
Cc: linux-wireless <linux-wireless@vger.kernel.org>, jt@hpl.hp.com
In-Reply-To: <20080227182613.GE3078@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1ba2fa240802270940te95e776n4958ff6b9f5beb20@mail.gmail.com>
	 <20080227182613.GE3078@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 27, 2008 at 8:26 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Wed, Feb 27, 2008 at 07:40:07PM +0200, Tomas Winkler wrote:
>
>
> > Does anybody knows why this section is missing from in kernel linux/wireless.h
>  >
>  > struct iw_range {
>  >
>  > ......
>  >
>  >
>  >         /* More power management stuff */
>  >         __s32           min_pms;        /* Minimal PM saving */
>  >         __s32           max_pms;        /* Maximal PM saving */
>  >         __u16           pms_flags;      /* How to decode max/min PM saving */
>  >
>  >         /* All available modulations for driver (hw may support less) */
>  >         __s32           modul_capa;     /* IW_MODUL_* bit field */
>  >
>  >         /* More bitrate stuff */
>  >         __u32           bitrate_capa;   /* Types of bitrates supported */
>  > };
>
>  Those were in Jean's original WE-21 patch.  They got
>  dropped in the redacted version of WE-21 I applied in commit
>  baef186519c69b11cf7e48c26e75feb1e6173baa.  Please see these threads:
>
>         http://marc.info/?l=linux-netdev&m=115689985827349&w=2
>         http://marc.info/?l=linux-netdev&m=115757728300747&w=2
>
>  Hth!
>
>  John
>  --
>  John W. Linville
>  linville@tuxdriver.com
>

Thanks for answer. It's just that user space utility differs from what
is in kernel which is a bit odd
Tomas
