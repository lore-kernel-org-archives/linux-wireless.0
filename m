Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:37753 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab1HXU7a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 16:59:30 -0400
Received: by yie30 with SMTP id 30so1187402yie.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 13:59:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110824215309.2f2cbb73@milhouse>
References: <4e5553a8.vSmpTZc2Cr8jeze3%Larry.Finger@lwfinger.net>
	<20110824215309.2f2cbb73@milhouse>
Date: Wed, 24 Aug 2011 22:59:29 +0200
Message-ID: <CACna6ryD8O4wURFFkS3a3w5pSOoe7L4hbGHug22L_Tghenzv0A@mail.gmail.com> (sfid-20110824_225935_347584_CD073BC8)
Subject: Re: [RFC/RFT] b43: Relax requirement for descriptors to be in the DMA zone
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/8/24 Michael Büsch <m@bues.ch>:
> On Wed, 24 Aug 2011 14:40:24 -0500
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
>> @Rafal - Incorporate this in your other patch.
>
> I would rather like to have this as a separate patch and have
> Rafal's other patch apply on _top_ of this.

/me agrees

Larry: don't care about my patches, do this one and I'll rebase my one.

-- 
Rafał
