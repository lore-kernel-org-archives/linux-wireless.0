Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:9597 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753940AbdLUQOn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Dec 2017 11:14:43 -0500
From: Rakesh Pillai <pillair@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 0/3] Core changes for wcn3990
Date: Thu, 21 Dec 2017 16:14:35 +0000
Message-ID: <7cf8b9f490ca47c4958d1bb5df439b04@aphydexm01b.ap.qualcomm.com> (sfid-20171221_171449_939278_DD3D55F2)
References: <1513854887-10759-1-git-send-email-pillair@qti.qualcomm.com>
 <87tvwkchfe.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87tvwkchfe.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

I have rebased the patchset on the latest ath.git and sent v2 for the chang=
e.

Thanks,
Rakesh Pillai

> -----Original Message-----
> From: Kalle Valo
> Sent: Thursday, December 21, 2017 7:27 PM
> To: Rakesh Pillai <pillair@qti.qualcomm.com>
> Cc: ath10k@lists.infradead.org; linux-wireless@vger.kernel.org
> Subject: Re: [PATCH 0/3] Core changes for wcn3990
>=20
> Rakesh Pillai <pillair@qti.qualcomm.com> writes:
>=20
> > This patchset includes the core changes for wcn3990 to
> > - Add SNOC bus type used for wcn3990 target
> > - Add the debug mask for SNOC bus type
> > - Adding fw feature flag for non-bmi firmware load, since wcn3990
> >   firmware is not loaded by bmi
> >
> > Govind Singh (2):
> >   ath10k: Add SNOC bus type for WCN3990 target
> >   ath10k: Add debug mask for SNOC bus type
> >
> > Rakesh Pillai (1):
> >   ath10k: Add fw feature flag for non-bmi firmware load
>=20
> What did you use as the baseline for these patches? While I was trying
> to get these to the pending branch for build testing I noticed they
> don't apply to any of ath.git branches and git can't even find the
> baseline sha1 information:
>=20
> $ git am -s -3 10127467.mbox
> Applying: ath10k: Add SNOC bus type for WCN3990 target
> Applying: ath10k: Add debug mask for SNOC bus type
> Applying: ath10k: Add fw feature flag for non-bmi firmware load
> fatal: sha1 information is lacking or useless
> (drivers/net/wireless/ath/ath10k/core.c).
> error: could not build fake ancestor
> Patch failed at 0003 ath10k: Add fw feature flag for non-bmi firmware loa=
d
> The copy of the patch that failed is found in: .git/rebase-apply/patch
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".
>=20
> --
> Kalle Valo
