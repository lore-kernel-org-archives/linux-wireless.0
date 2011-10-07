Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57560 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab1JGPrw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 11:47:52 -0400
Received: by qyk7 with SMTP id 7so3763386qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Oct 2011 08:47:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317988039-28632-13-git-send-email-rmanohar@qca.qualcomm.com>
References: <1317988039-28632-1-git-send-email-rmanohar@qca.qualcomm.com> <1317988039-28632-13-git-send-email-rmanohar@qca.qualcomm.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Fri, 7 Oct 2011 08:47:31 -0700
Message-ID: <CAB=NE6WvKg-M2QWErcnd_ZXo7tWbRTuy2ORt5e5pShLkfUR1Tw@mail.gmail.com> (sfid-20111007_174756_038418_61770A86)
Subject: Re: [PATCH 13/14] ath9k_hw: Rename AR9480 -> AR9462 initvals
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 7, 2011 at 4:47 AM, Rajkumar Manoharan
<rmanohar@qca.qualcomm.com> wrote:
> The AR946/8x chips are 2x2 Dual band with BT support. In order
> to avoid misleading with other chips and to be in sync with
> marketing team's term, AR9480 is renamed as AR9462.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

Please generate this patch with git format-patch -M. Also in your
.gitconfig please add:

[diff]
        renamelimit=0

  Luis
