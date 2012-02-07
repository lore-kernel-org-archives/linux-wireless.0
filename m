Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40736 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841Ab2BGV52 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 16:57:28 -0500
Received: by iacb35 with SMTP id b35so10678958iac.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2012 13:57:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328542936-20963-1-git-send-email-sidhayn@gmail.com>
References: <1328542936-20963-1-git-send-email-sidhayn@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 7 Feb 2012 13:57:08 -0800
Message-ID: <CAB=NE6Vhi=7uT3i6T-oEdX1rDaJfPdnv3YX5eadKeqGqiDuXqg@mail.gmail.com> (sfid-20120207_225732_105375_92964735)
Subject: Re: [PATCH] add missing =y to CONFIG_RT2X00_LIB_DEBUGFS
To: Rick Farina <sidhayn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 6, 2012 at 7:42 AM, Rick Farina <sidhayn@gmail.com> wrote:
> When editing config.mk with a sed script the missing =y on this line
> causes issue. Since this line is commented out by default this means no
> changes to the default behavior and sed scripts will be able to edit the
> config.mk file much more easily.
>
> Signed-of-By: Rick Farina <sidhayn@gmail.com>

Applied and pushed, thanks!

  Luis
