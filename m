Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:42437 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610AbZLSBSc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 20:18:32 -0500
Received: by mail-iw0-f171.google.com with SMTP id 1so2559628iwn.33
        for <linux-wireless@vger.kernel.org>; Fri, 18 Dec 2009 17:18:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091217124225.GA3068@atheros-laptop>
References: <20091217124225.GA3068@atheros-laptop>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 18 Dec 2009 17:18:12 -0800
Message-ID: <43e72e890912181718r78ea33eand142bf79f60daac@mail.gmail.com>
Subject: Re: [RFC]compat-wireless: modules declared as PHONY target in
	Makefile
To: Bala Shanmugam <sbalashanmugam@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	mcgrof@bombadil.infradead.org,
	Jothikumar Mothilal <Jothikumar.Mothilal@atheros.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 17, 2009 at 4:42 AM, Bala Shanmugam
<sbalashanmugam@atheros.com> wrote:
> When a particular file alone is modified in compat package, it is not compiled with make.
> To compile the modified file compat package needs to be cleaned up and all files need to be compiled.
> This is because all files are compiled in modules target, and file by name modules is not generated.
> So this target will be considered up-to-date once compiled.
>
> modules target is declared as PHONY target to avoid this problem.
>
> I feel config.mk need not be included when KERNELRELEASE is not NULL as
> it degrades the performance and doesn't make any difference.  Please comment.
>
> Signed-off-by: Bala Shanmugam <sbalashanmugam@atheros.com>

I was wondering what caused that to happen, thanks applied.

  Luis
