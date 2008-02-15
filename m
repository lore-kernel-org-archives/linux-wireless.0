Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:44722 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763769AbYBOWcu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 17:32:50 -0500
Received: by py-out-1112.google.com with SMTP id u52so1048187pyb.10
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2008 14:32:49 -0800 (PST)
Message-ID: <43e72e890802151432v2729bb58j505cf3994c623d2e@mail.gmail.com> (sfid-20080215_223318_729346_FC05651D)
Date: Fri, 15 Feb 2008 17:32:48 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 3/3] WDEV: ath5k, typecheck on nonDEBUG
Cc: linville@tuxdriver.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	"Nick Kossifidis" <mickflemm@gmail.com>
In-Reply-To: <1203109133-32217-3-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1203109133-32217-1-git-send-email-jirislaby@gmail.com>
	 <1203109133-32217-3-git-send-email-jirislaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 15, 2008 at 3:58 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> At least type check the ATH5K_TRACE paramter on !ATH5K_DEBUG configs.

That's pretty cool.

>  Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>  Cc: Nick Kossifidis <mickflemm@gmail.com>
>  Cc: Luis R. Rodriguez <mcgrof@gmail.com>

Acked-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

  Luis
