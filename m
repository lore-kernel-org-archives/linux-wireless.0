Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:63843 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbZAZR1l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 12:27:41 -0500
Received: by ewy14 with SMTP id 14so776530ewy.13
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 09:27:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1232989251-21311-1-git-send-email-lrodriguez@atheros.com>
References: <1232989251-21311-1-git-send-email-lrodriguez@atheros.com>
Date: Mon, 26 Jan 2009 18:27:37 +0100
Message-ID: <69e28c910901260927uaeedb6fpd8b14c7f93f51a80@mail.gmail.com> (sfid-20090126_182746_568292_4005365F)
Subject: Re: [PATCH] cfg80211: do not pass -EALREADY to userspace on regdomain
	change request
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 26, 2009 at 6:00 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> +        * we don't want to confuse userspace with a "successfull error"

Typo.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
