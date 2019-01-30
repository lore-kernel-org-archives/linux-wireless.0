Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C58DC282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28F3D20811
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730083AbfA3Luw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 06:50:52 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:52696 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727142AbfA3Luw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 06:50:52 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gooOI-0003wh-8e; Wed, 30 Jan 2019 13:50:50 +0200
Message-ID: <57b89f3bd6db01fa84f59c1e07f919853af636fe.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Wed, 30 Jan 2019 13:50:48 +0200
In-Reply-To: <87lg32jta2.fsf@kamboji.qca.qualcomm.com>
References: <7e68c48a5c59b164a28d434765b03cba6243c12f.camel@coelho.fi>
         <87lg32jta2.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: pull-request: iwlwifi-next 2019-01-29
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-01-30 at 13:09 +0200, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > This is the second batch of patches intended for v5.1.  This
> > includes
> > the last two patchsets I sent.  Usual development work.  More
> > details
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
> > The following changes since commit
> > 64e2330580fbbfa7077ef2f608555f07e0bb4956:
> > 
> >   Merge tag 'iwlwifi-next-for-kalle-2019-01-25' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
> > (2019-01-29 14:56:05 +0200)
> > 
> > are available in the Git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-
> > next.git tags/iwlwifi-next-for-kalle-2019-01-29
> > 
> > for you to fetch changes up to
> > 01f377dc927da6e42cbffb00fc8d431c8341da3f:
> > 
> >   iwiwifi: fix bad monitor buffer register addresses (2019-01-29
> > 16:10:33 +0200)
> > 
> > ----------------------------------------------------------------
> > Second batch of iwlwifi patches intended for v5.1
> > 
> > * A bunch of fixes for issues found with static analyzers;
> > * Relicense the pcie submodule to dual GPL/BSD;
> > * Reworked the TOF/CSI implementation;
> > * Work on new debugging infra continues;
> > * Some product name updates in the human-readable strings
> > * Some more cleanups for the device configuration refactoring;
> > * General bugfixes;
> > * Other cleanups and small fixes;
> > 
> > ----------------------------------------------------------------
> 
> Pulled, thanks.
> 
> Oh, but I see a new warning:
> 
> drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c:195:13: warning:
> 'iwl_mvm_add_rtap_sniffer_config' defined but not used [-Wunused-
> function]
>  static void iwl_mvm_add_rtap_sniffer_config(struct iwl_mvm *mvm,
>              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Can you send separately a patch to fix this so that I can apply it
> directly?

Ugh, I broke something when resolving conflicts.  I'll send a fix asap.

--
Luca.

