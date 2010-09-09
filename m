Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56159 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab0IICIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 22:08:04 -0400
Received: by bwz11 with SMTP id 11so723095bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 19:08:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1283988329-44549-7-git-send-email-steve@cozybit.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com> <1283988329-44549-7-git-send-email-steve@cozybit.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 9 Sep 2010 12:07:43 +1000
Message-ID: <AANLkTinsK63ySOssZUf6kHWp4piurjgQNBY7A4Sd9yaP@mail.gmail.com>
Subject: Re: [PATCH 6/9] libertas_tf: Fix to enable interrupts even when
 firmware has already started
To: Steve deRosier <steve@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, javier@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 9, 2010 at 09:25, Steve deRosier <steve@cozybit.com> wrote:
>
> Signed-off-by: Steve deRosier <steve@cozybit.com>
> ---
>  drivers/net/wireless/libertas_tf/main.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)

Shouldn't this be rolled into the previous patch?

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
