Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:34267 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbcA1ORR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 09:17:17 -0500
Received: by mail-pf0-f172.google.com with SMTP id o185so19629361pfb.1
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jan 2016 06:17:15 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Joe Perches <joe@perches.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Steve French <sfrench@samba.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>, x86@kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] lib: add "on" and "off" to strtobool
Date: Thu, 28 Jan 2016 06:17:04 -0800
Message-Id: <1453990627-19164-1-git-send-email-keescook@chromium.org> (sfid-20160128_151734_098041_422A6FEC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This consolidates logic for handling "on"/"off" parsing for bools into
the existing strtobool function. This requires making sure callers are
passing NULL-terminated strings.

-Kees

