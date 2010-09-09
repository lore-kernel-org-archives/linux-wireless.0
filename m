Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65067 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab0IICVc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 22:21:32 -0400
Received: by bwz11 with SMTP id 11so730808bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 19:21:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1283988329-44549-9-git-send-email-steve@cozybit.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com> <1283988329-44549-9-git-send-email-steve@cozybit.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 9 Sep 2010 12:21:11 +1000
Message-ID: <AANLkTi=-62L5C02bG_UrTjV0VUE5AZ35C_223vXiRXei@mail.gmail.com>
Subject: Re: [PATCH 8/9] libertas_tf: updated with beacon code
To: Steve deRosier <steve@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, javier@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 9, 2010 at 09:25, Steve deRosier <steve@cozybit.com> wrote:
>
> Signed-off-by: Steve deRosier <steve@cozybit.com>

It'd be nice if the subject line of this patch was a bit more descriptive.

Something like "libertas_tf: Update beacon code" would be descriptive.

Also, it appears that this patch does two things, update the beacon
code and add some debugging. You may want to separate this into two
patches.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
