Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:47505 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaJOUw2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2014 16:52:28 -0400
MIME-Version: 1.0
In-Reply-To: <20141009095939.GB20875@mwanda>
References: <20141009095939.GB20875@mwanda>
Date: Wed, 15 Oct 2014 13:52:27 -0700
Message-ID: <CA++WF2N4v20EqEaH-DnKAEzn4PwHWQHBEq6=Uthf7TsRZpimEg@mail.gmail.com> (sfid-20141015_225233_501200_B9B89554)
Subject: Re: [patch 2/2] ipw2x00: clean up a condition
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Dan,

On 9 October 2014 02:59, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> The original condition was "(PAGE_SIZE - len)" when "(len < PAGE_SIZE)"
> is intended.
>
> This condition is not really sufficient, but also not really needed...
> If "len > PAGE_SIZE" then it we will print a warning message in dmesg
> but there are no other effects.  Maybe we should just remove the
> condition?
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Looks fine, thanks.

Stanislav.
