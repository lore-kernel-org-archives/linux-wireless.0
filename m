Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:53162 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933869Ab3HHHHO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 03:07:14 -0400
Received: by mail-la0-f54.google.com with SMTP id ea20so1818560lab.41
        for <linux-wireless@vger.kernel.org>; Thu, 08 Aug 2013 00:07:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFr7H3WU3djGrj_bGZBWnbA23=CapO85zRgAJH_QUEX+nWHjXA@mail.gmail.com>
References: <1375881466-30090-1-git-send-email-bartosz.markowski@tieto.com>
	<CAFr7H3WU3djGrj_bGZBWnbA23=CapO85zRgAJH_QUEX+nWHjXA@mail.gmail.com>
Date: Thu, 8 Aug 2013 09:07:12 +0200
Message-ID: <CACKGw+E=v=JGD5Swakq0rrSiqN73NZPKh5ccUSPC1VDvcd6b0A@mail.gmail.com> (sfid-20130808_090719_773765_FC32CCF3)
Subject: Re: [PATCH 1/2] ath10k: Remove qca98xx hw1.0 support
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: =?UTF-8?B?5p2o5p6t?= <m3yangxiao@gmail.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 August 2013 15:34, 杨枭 <m3yangxiao@gmail.com> wrote:
> Hi,I want to know which kernel does the ath10k support?
It has been pull to 3.11-rc track.

> Can I install it on the kernel-2.6?
> If not,what's the oldest kernel can the ath10k support?
You may use a compat-drivers backport to compile it.
--
Bartosz
