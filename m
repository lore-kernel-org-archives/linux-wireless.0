Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f182.google.com ([209.85.128.182]:55379 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab3FVCpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jun 2013 22:45:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130621122620.GC24059@elgon.mountain>
References: <20130621122620.GC24059@elgon.mountain>
Date: Fri, 21 Jun 2013 19:45:53 -0700
Message-ID: <CA++WF2NXrbHi4DN112QxAiGDtYuGL6MYcvbV-7R4opcpHeVuaA@mail.gmail.com> (sfid-20130622_044558_802466_730CD86B)
Subject: Re: [patch] ipw2x00: printing the wrong array in debug code
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On 21 June 2013 05:26, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Smatch complains that this is a read past the end of the array.  It
> turns out we are printing the wrong array here.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>

Looks fine, thanks.

Stanislav.
