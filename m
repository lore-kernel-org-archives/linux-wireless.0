Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59417 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab3JAKYM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 06:24:12 -0400
Message-ID: <1380623046.14430.10.camel@jlt4.sipsolutions.net> (sfid-20131001_122436_423978_AAAEFBBA)
Subject: Re: [PATCH] doc: fix some typos in documentations
From: Johannes Berg <johannes@sipsolutions.net>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: rob@landley.net, Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Date: Tue, 01 Oct 2013 12:24:06 +0200
In-Reply-To: <523921BD.3030205@huawei.com>
References: <523921BD.3030205@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-09-18 at 11:45 +0800, Xishi Qiu wrote:
>  
>  to ensure the driver cannot be built-in when rfkill is modular. The !RFKILL
> -case allows the driver to be built when rfkill is not configured, which which
> +case allows the driver to be built when rfkill is not configured, which
>  case all rfkill API can still be used but will be provided by static inlines
>  which compile to almost nothing.

It looks like this was intended to say "in which" instead of the "which
which" you remove, rather than just "which".

johannes

