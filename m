Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64218 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758187Ab2HKAua (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 20:50:30 -0400
Received: by obbuo13 with SMTP id uo13so3032582obb.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2012 17:50:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344632236-516-1-git-send-email-andy@greyhouse.net>
References: <1344632236-516-1-git-send-email-andy@greyhouse.net>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Fri, 10 Aug 2012 17:50:09 -0700
Message-ID: <CAB=NE6V8cs81zghucNHGG=LrjxLg9tNb_2CRmihJp7OYEv30pQ@mail.gmail.com> (sfid-20120811_025143_156936_68788251)
Subject: Re: [PATCH] compat: fixup error in no_printk definition
To: Andy Gospodreak <andy@greyhouse.net>
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 10, 2012 at 1:57 PM, Andy Gospodreak <andy@greyhouse.net> wrote:
> What initially looked like a valid definition for the #define for
> no_printk was not.  This corrects the problem and the change that was
> thought to correct it.
>
> Signed-off-by: Andy Gospodarek <andy@greyhouse.net>

thanks, applied and pushed!
