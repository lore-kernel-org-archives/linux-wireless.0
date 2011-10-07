Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54264 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab1JGPt4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 11:49:56 -0400
Received: by qyk7 with SMTP id 7so3766112qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Oct 2011 08:49:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317988039-28632-9-git-send-email-rmanohar@qca.qualcomm.com>
References: <1317988039-28632-1-git-send-email-rmanohar@qca.qualcomm.com> <1317988039-28632-9-git-send-email-rmanohar@qca.qualcomm.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Fri, 7 Oct 2011 08:49:35 -0700
Message-ID: <CAB=NE6XLSr08L3f1DFZawX+U71xuAjmwRMMMABKuYKUXdidriw@mail.gmail.com> (sfid-20111007_175003_747349_A685C715)
Subject: Re: [PATCH 09/14] ath9k_hw: Fix ASPM L1 issue for AR9480
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 7, 2011 at 4:47 AM, Rajkumar Manoharan
<rmanohar@qca.qualcomm.com> wrote:
> Because of not clearing Bit 14 of AR_WA, the ASPM L1 is not
> enabled when entering into sleep mode. AR9480 does not need
> bit 14 to be set.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

Is this a stable fix?

  Luis
