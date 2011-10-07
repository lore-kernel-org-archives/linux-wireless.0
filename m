Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64584 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760135Ab1JGQYV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 12:24:21 -0400
Date: Fri, 7 Oct 2011 21:55:04 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 13/14] ath9k_hw: Rename AR9480 -> AR9462 initvals
Message-ID: <20111007162503.GA860@vmraj-lnx.users.atheros.com> (sfid-20111007_182427_322939_55A35EBD)
References: <1317988039-28632-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1317988039-28632-13-git-send-email-rmanohar@qca.qualcomm.com>
 <CAB=NE6WvKg-M2QWErcnd_ZXo7tWbRTuy2ORt5e5pShLkfUR1Tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAB=NE6WvKg-M2QWErcnd_ZXo7tWbRTuy2ORt5e5pShLkfUR1Tw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 07, 2011 at 08:47:31AM -0700, Luis R. Rodriguez wrote:
> On Fri, Oct 7, 2011 at 4:47 AM, Rajkumar Manoharan
> <rmanohar@qca.qualcomm.com> wrote:
> > The AR946/8x chips are 2x2 Dual band with BT support. In order
> > to avoid misleading with other chips and to be in sync with
> > marketing team's term, AR9480 is renamed as AR9462.
> >
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> 
> Please generate this patch with git format-patch -M. Also in your
> .gitconfig please add:
> 
> [diff]
>         renamelimit=0
Sure ;)

--
Rajkumar
