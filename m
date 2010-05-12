Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52046 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab0ELHAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 03:00:13 -0400
Received: by fxm4 with SMTP id 4so224042fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 00:00:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273614705-25118-6-git-send-email-gwingerde@gmail.com>
References: <1273614705-25118-1-git-send-email-gwingerde@gmail.com>
	 <1273614705-25118-6-git-send-email-gwingerde@gmail.com>
Date: Wed, 12 May 2010 09:00:11 +0200
Message-ID: <AANLkTil6_j-Xi7OLKGh1BvWSH6OhfiunzaPdsO_UsNAy@mail.gmail.com>
Subject: Re: [PATCH 5/9] rt2x00: Dump beacons under a different identifier
	than TX frames.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 11, 2010 at 11:51 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> This allows for specific identification of beacons in the debugfs
> frame stream.
> Preparation for later differences between dumped TX frames and dumped
> beacons.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
