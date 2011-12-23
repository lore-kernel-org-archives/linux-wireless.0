Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43362 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab1LWPRL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 10:17:11 -0500
Received: by iaeh11 with SMTP id h11so15228020iae.19
        for <linux-wireless@vger.kernel.org>; Fri, 23 Dec 2011 07:17:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1324586850-5212-1-git-send-email-hauke@hauke-m.de>
References: <1324586850-5212-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Fri, 23 Dec 2011 07:16:50 -0800
Message-ID: <CAB=NE6WwSpBMED9+TqmAAhufFxvLT=AVpfwWRUn=SB=ZWccLpg@mail.gmail.com> (sfid-20111223_161714_827735_ABC8B74B)
Subject: Re: [PATCH 0/6] compat-wireless: various fixes
To: Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 22, 2011 at 12:47 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This make compat-wireless apply against current linux-next and build
> with kernel version from 2.6.27 to 3.2. This series just contains some
> patches handing some recent changes in linux-next nothing special.

Thanks so much, applied and pushed!

In the future please provide a description of the patches added to
patches/, I've added your description this time. This helps other
driver writers who need such functionality understand why this is done
but also sets a bar for adding patches into compat-wireless vs adding
something to the generic compat module.

  Luis
