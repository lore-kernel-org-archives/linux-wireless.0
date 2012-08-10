Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46522 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab2HJLoz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 07:44:55 -0400
Received: by yenl14 with SMTP id l14so204239yen.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2012 04:44:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <502408EB.3020905@hauke-m.de>
References: <1344535292-4451-1-git-send-email-ozancag@gmail.com>
	<1344535292-4451-11-git-send-email-ozancag@gmail.com>
	<502408EB.3020905@hauke-m.de>
Date: Fri, 10 Aug 2012 14:44:54 +0300
Message-ID: <CAFub=KSr6sa3PDfvX2K63BM_VrpgWd7KgL5T7oekcLGPxs3wZQ@mail.gmail.com> (sfid-20120810_134459_697648_E6450126)
Subject: Re: [PATCH 10/13] compat-wireless: Selectively apply patches
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 9, 2012 at 10:00 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:

> The folder network does not exists in this patch, this will break git
> bisect. Could you add the move of the patches from patches to network in
> this commit.

Ah, Okay.

>
> I do not like the name network for the folder containing the patches,
> because it could easily be to mixed up with the net folder. What about
> patches-net as the folder name?

It is already under patches/, e.g. patches/network and patches/drm.






-- 
Ozan Çağlayan
