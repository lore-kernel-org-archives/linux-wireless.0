Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:65410 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362AbaHVNdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 09:33:00 -0400
Received: by mail-la0-f43.google.com with SMTP id gi9so7555109lab.30
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 06:32:59 -0700 (PDT)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: net: wireless: Add include guards
References: <1408710414-13810-1-git-send-email-linux@rasmusvillemoes.dk>
Date: Fri, 22 Aug 2014 15:32:58 +0200
In-Reply-To: <1408710414-13810-1-git-send-email-linux@rasmusvillemoes.dk>
	(Rasmus Villemoes's message of "Fri, 22 Aug 2014 14:26:54 +0200")
Message-ID: <87egw8sl85.fsf@rasmusvillemoes.dk> (sfid-20140822_153326_782040_CDFDDF33)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:

> The files ray_cs.h and rayctl.h both contain two thirds of what
> appears to be an include guard using the macro name RAYLINK_H (both
> lack the #define). Since RAYLINK_H is not defined anywhere, the
> guards using different macro names.
>

I need to stop using the # character in my commit messages, or at least
check that git didn't eat any of my lines.

This was supposed to be something like "... defined anywhere, the
#ifndefs are simply confusing no-ops. Add proper include guards using
different macro names".

Rasmus
