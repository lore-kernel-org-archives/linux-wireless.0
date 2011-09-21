Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33466 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab1IUUFM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 16:05:12 -0400
Received: by gyg10 with SMTP id 10so1457348gyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 13:05:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E7827EC.2030302@pardus.org.tr>
References: <4E7827EC.2030302@pardus.org.tr>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Wed, 21 Sep 2011 13:04:52 -0700
Message-ID: <CAB=NE6VxgD3AQS1W7x41mpREJvP0pCUy8Jr2RPeUN-o+eATfuA@mail.gmail.com> (sfid-20110921_220519_144907_72D8C1F1)
Subject: Re: Fix compat-wireless build on 2.6.37
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/9/19 Ozan Çağlayan <ozan@pardus.org.tr>:
> Hi,
>
> The following fix should be applied to the compat tree to fix a build error
> in wl12xx. Since kernel.org is down, I couldn't fetch the compat tree to
> post a patch with git send-email.

The git trees for compat and compat-wireless are mirrored on two locations:

https://github.com/mcgrof/
http://git.infradead.org/

  Luis
