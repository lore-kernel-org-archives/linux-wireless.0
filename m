Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41452 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab1JGQ2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 12:28:11 -0400
Date: Fri, 7 Oct 2011 21:57:17 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 09/14] ath9k_hw: Fix ASPM L1 issue for AR9480
Message-ID: <20111007162716.GB860@vmraj-lnx.users.atheros.com> (sfid-20111007_182815_676555_339C96C1)
References: <1317988039-28632-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1317988039-28632-9-git-send-email-rmanohar@qca.qualcomm.com>
 <CAB=NE6XLSr08L3f1DFZawX+U71xuAjmwRMMMABKuYKUXdidriw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAB=NE6XLSr08L3f1DFZawX+U71xuAjmwRMMMABKuYKUXdidriw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 07, 2011 at 08:49:35AM -0700, Luis R. Rodriguez wrote:
> On Fri, Oct 7, 2011 at 4:47 AM, Rajkumar Manoharan
> <rmanohar@qca.qualcomm.com> wrote:
> > Because of not clearing Bit 14 of AR_WA, the ASPM L1 is not
> > enabled when entering into sleep mode. AR9480 does not need
> > bit 14 to be set.
> >
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> 
> Is this a stable fix?
>
Hmmm...Right it is applicable to 3.1.0+

--
Rajkumar
