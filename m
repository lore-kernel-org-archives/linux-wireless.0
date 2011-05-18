Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58950 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab1ERA2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 20:28:43 -0400
Received: by iyb14 with SMTP id 14so866224iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 17:28:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305677203-16660-2-git-send-email-zajec5@gmail.com>
References: <1305677203-16660-1-git-send-email-zajec5@gmail.com> <1305677203-16660-2-git-send-email-zajec5@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 18 May 2011 10:28:23 +1000
Message-ID: <BANLkTinh7VVGUtEUezk3mODqpQ9zPT022Q@mail.gmail.com> (sfid-20110518_022847_591803_9FFF4B3D)
Subject: Re: [PATCH 2/9] b43: add bus device abstraction layer
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał,

A quick question:

2011/5/18 Rafał Miłecki <zajec5@gmail.com>:
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/net/wireless/b43/Makefile |    1 +
>  drivers/net/wireless/b43/b43.h    |    4 +++-
>  drivers/net/wireless/b43/bus.c    |   36 ++++++++++++++++++++++++++++++++++++

Would it make more sense to have this be called ssb.c as it contains
all the ssb specific functions, that way you can then have an brcma.c
file to contain the functions specific to that bus?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
