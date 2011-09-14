Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46967 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab1INJeD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 05:34:03 -0400
Received: by qyk30 with SMTP id 30so3645113qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 02:34:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1315990697-3575-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1315990697-3575-1-git-send-email-rmanohar@qca.qualcomm.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 14 Sep 2011 02:33:42 -0700
Message-ID: <CAB=NE6WqtcM_wTEgSHzZqEZB3fzman_XBUc+OLBLq_QgmGCYbQ@mail.gmail.com> (sfid-20110914_113407_516014_B7424266)
Subject: Re: [PATCH] wireless: Reset beacon_found while updating regulatory
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 14, 2011 at 1:58 AM, Rajkumar Manoharan
<rmanohar@qca.qualcomm.com> wrote:
> During the association, the regulatory is updated by country IE
> that reaps the previously found beacons. The impact is that
> after a STA disconnects *or* when for any reason a regulatory
> domain change happens the beacon hint flag is not cleared
> therefore preventing future beacon hints to be learned.
> This is important as a regulatory domain change or a restore
> of regulatory settings would set back the passive scan and no-ibss
> flags on the channel. This is the right place to do this given that
> it covers any regulatory domain change.
>
> Cc: stable@kernel.org
> Reviewed-by: Luis R. Rodriguez <mcgrof@gmail.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

  Luis
