Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36586 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbcGHJVT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 05:21:19 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: iwlwifi-next 2016-07-06
References: <1467801452.25088.20.camel@coelho.fi>
Date: Fri, 08 Jul 2016 12:21:12 +0300
In-Reply-To: <1467801452.25088.20.camel@coelho.fi> (Luca Coelho's message of
	"Wed, 06 Jul 2016 13:37:32 +0300")
Message-ID: <87furk1o53.fsf@kamboji.qca.qualcomm.com> (sfid-20160708_112122_590387_410CF5BF)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Hi Kalle,
>
> I have a lot of patches for 4.8.  Sorry for the patch bomb, but I
> wanted to go over our internal tree and publish everything before my
> vacations started.  I hope this is okay.
>
> It has changes all over, but mostly some datapath rework in preparation
> for new HW, some foundation for the new HW as well as dynamic queue
> allocation work and lots of other cleanups and bugfixes.
>
> Let me know if everything's fine (or not). :)
>
> Luca.
>
>
> The following changes since commit 58035432d60616cc2ef6514a3d0e6d6ad01bf705:
>
>   iwlwifi: mvm: handle FRAME_RELEASE in MQ code (2016-07-01 18:09:46 +0300)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2016-07-06

Pulled, thanks.

-- 
Kalle Valo
