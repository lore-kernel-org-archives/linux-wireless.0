Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64098 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002Ab2AMCHY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 21:07:24 -0500
Received: by iabz25 with SMTP id z25so3587788iab.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jan 2012 18:07:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACna6rxffpPhYVqKNttu79JET=NkBP4NrAayywQHWcj=mw=T9A@mail.gmail.com>
References: <1326315180-29398-1-git-send-email-linville@tuxdriver.com> <CACna6rxffpPhYVqKNttu79JET=NkBP4NrAayywQHWcj=mw=T9A@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 13 Jan 2012 13:07:03 +1100
Message-ID: <CAGRGNgUkBUvoBJydcdprBXP0ufR+PQ6nXFXdW546xjHbQ-O2Bg@mail.gmail.com> (sfid-20120113_030728_400395_A5CED789)
Subject: Re: [PATCH] b43: add default option to avoid duplicating device
 support with brcmsmac
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/1/13 Rafał Miłecki <zajec5@gmail.com>:
> 2012/1/11 John W. Linville <linville@tuxdriver.com>:
>> +config B43_BCMA_EXTRA
>> +       bool "Support for devices also supported by brcmsmac"
>> +       depends on B43_BCMA
>> +       default n
>> +
>
> Is this really *the* solution? I wonder if we can do whatever you're
> trying to do in a better way? To let final users try both drivers
> without recompiling kernel?

Another issue is that this should arguably be default y if brcmsmac is disabled.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
