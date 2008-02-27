Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:6024 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbYB0RkI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 12:40:08 -0500
Received: by wa-out-1112.google.com with SMTP id v27so3353556wah.23
        for <linux-wireless@vger.kernel.org>; Wed, 27 Feb 2008 09:40:07 -0800 (PST)
Message-ID: <1ba2fa240802270940te95e776n4958ff6b9f5beb20@mail.gmail.com> (sfid-20080227_174012_116503_4170BA8D)
Date: Wed, 27 Feb 2008 19:40:07 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>, jt@hpl.hp.com
Subject: linux/wireless.h - missing section
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Does anybody knows why this section is missing from in kernel linux/wireless.h

struct iw_range {

......


        /* More power management stuff */
        __s32           min_pms;        /* Minimal PM saving */
        __s32           max_pms;        /* Maximal PM saving */
        __u16           pms_flags;      /* How to decode max/min PM saving */

        /* All available modulations for driver (hw may support less) */
        __s32           modul_capa;     /* IW_MODUL_* bit field */

        /* More bitrate stuff */
        __u32           bitrate_capa;   /* Types of bitrates supported */
};

Thanks
Tomas
