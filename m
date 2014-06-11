Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:58978 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaFKIac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 04:30:32 -0400
Received: by mail-lb0-f178.google.com with SMTP id w7so4625056lbi.9
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 01:30:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1402471415-22723-1-git-send-email-arik@wizery.com>
References: <1402471415-22723-1-git-send-email-arik@wizery.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 11 Jun 2014 01:30:09 -0700
Message-ID: <CAB=NE6XQoPOot0gvzgEm-ZtPh+1_8-jZR+ME50tFccmrnFkezA@mail.gmail.com> (sfid-20140611_103037_206217_CC64A1E7)
Subject: Re: [PATCH] regulatory: add NULL to alpha2
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Eliad Peller <eliad@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2014 at 12:23 AM, Arik Nemtsov <arik@wizery.com> wrote:
> From: Eliad Peller <eliad@wizery.com>
>
> alpha2 is defined as 2-chars array, but is used in multiple
> places as string (e.g. with nla_put_string calls), which
> might leak kernel data.
>
> Solve it by simply adding an extra char for the NULL
> terminator, making such operations safe.
>
> Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
> Reviewed-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

Thanks for the patch ! Curious how you ended up down finding the issue though.

  Luis
