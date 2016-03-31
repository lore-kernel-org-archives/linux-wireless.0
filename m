Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:32893 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbcCaBm2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 21:42:28 -0400
Received: by mail-oi0-f53.google.com with SMTP id d205so40851423oia.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2016 18:42:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1459379297-21496-1-git-send-email-greearb@candelatech.com>
References: <1459379297-21496-1-git-send-email-greearb@candelatech.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 31 Mar 2016 12:41:54 +1100
Message-ID: <CAGRGNgWEua3EOePQFRS_AR5BnSUPUhFrudWs2hY7YPLizxnyhQ@mail.gmail.com> (sfid-20160331_034240_457128_E719804B)
Subject: Re: [PATCH] ath10k: Fix deadlock when peer cannot be created.
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

On Thu, Mar 31, 2016 at 10:08 AM,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> We must not attempt to send WMI packets while dholding the data-lock,

s/dholding/holding/ ?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
