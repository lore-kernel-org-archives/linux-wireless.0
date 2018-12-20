Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31FCEC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 12:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09DA421741
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 12:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731325AbeLTM1D (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 07:27:03 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:43196 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728613AbeLTM1C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 07:27:02 -0500
Received: from 201-0-74-183.dsl.telesp.net.br ([201.0.74.183] helo=dubbel)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gZxPn-0005lg-VY; Thu, 20 Dec 2018 14:27:01 +0200
Message-ID: <2c08f3e0845d900aa3a8b53b6d50cc214dd21dbf.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Thu, 20 Dec 2018 10:26:53 -0200
In-Reply-To: <877eg4vfcm.fsf@kamboji.qca.qualcomm.com>
References: <39a3a7b5a34332c62468771c57c06a2c6e40b7ab.camel@coelho.fi>
         <877eg4vfcm.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: pull-request: iwlwifi-next 2018-12-17
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2018-12-20 at 09:15 +0200, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > This is the fourht batch of patches intended for v4.21.  This includes
> > only the last patchset I sent.  Usual development work.  More details
> > about the contents in the tag description.
> > 
> > I have sent this out before and kbuildbot reported success.
> > 
> > Please let me know if there are any issues.
> > 
> > Cheers,
> > Luca.
> > 
> > 
> > The following changes since commit 30ed3c6c0922a1f67c3409b9e81087442614db7b:
> > 
> >   Merge tag 'iwlwifi-next-for-kalle-2018-12-14' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next (2018-12-14 16:58:00 +0200)
> > 
> > are available in the Git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2018-12-17
> > 
> > for you to fetch changes up to 04a70797e208337775c6a1905699e4970ed17f8b:
> > 
> >   iwlwifi: bump the API version to 43 for 9000 and 22000 (2018-12-17 23:07:30 -0200)
> > 
> > ----------------------------------------------------------------
> > Fourth batch of iwlwifi patches intended for v4.21
> > 
> > * Support for FW version 43 for 9000 and 22000 series;
> > * A couple of janitorial fixes from the community;
> > * More fixes in the 802.11ax code;
> > * Other cleanups and small fixes;
> > 
> > ----------------------------------------------------------------
> 
> Applied, thanks. I manually applied these as I had to rebase the patches
> to remove the stray "BUGFIX" from the patch title. So the commit ids
> have changed etc, I hope that doesn't break anything on your side.

Thanks! No, it doesn't break anything, I don't consider iwlwifi-next as
linear, though I usually try to keep it so.

--
Cheers,
Luca.

