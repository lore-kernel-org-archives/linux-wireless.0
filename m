Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF0AC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 08:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C728121852
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 08:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbeLSIb7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 03:31:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:53825 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbeLSIb7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 03:31:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2018 00:31:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,372,1539673200"; 
   d="scan'208";a="108519833"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga007.fm.intel.com with ESMTP; 19 Dec 2018 00:31:58 -0800
Received: from fmsmsx102.amr.corp.intel.com (10.18.124.200) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Wed, 19 Dec 2018 00:31:57 -0800
Received: from hasmsx108.ger.corp.intel.com (10.184.198.18) by
 FMSMSX102.amr.corp.intel.com (10.18.124.200) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Wed, 19 Dec 2018 00:31:57 -0800
Received: from hasmsx112.ger.corp.intel.com ([169.254.11.88]) by
 hasmsx108.ger.corp.intel.com ([169.254.9.61]) with mapi id 14.03.0415.000;
 Wed, 19 Dec 2018 10:31:54 +0200
From:   "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC:     Wireless <linux-wireless@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Sharon, Sara" <sara.sharon@intel.com>,
        "Coelho, Luciano" <luciano.coelho@intel.com>,
        Kees Cook <keescook@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "David Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Subject: RE: linux-next: build warnings after merge of the
 wireless-drivers-next tree
Thread-Topic: linux-next: build warnings after merge of the
 wireless-drivers-next tree
Thread-Index: AQHUl2/DznSNsdWt3UCII8zN8RybjKWFu5lQ
Date:   Wed, 19 Dec 2018 08:31:54 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB3013375F96C@HASMSX112.ger.corp.intel.com>
References: <20181130120555.1d35eb6b@canb.auug.org.au>
        <20181219134738.4efed34f@canb.auug.org.au>
 <871s6evtra.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <871s6evtra.fsf@kamboji.qca.qualcomm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYzVhOTY4YmQtZWZiOS00NDQ4LWE3YTMtNGMwMzkyYTA2MGFkIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiQ1U4dUFlQVNzWHpDZGVRaXBnTkhBZUM5U0dLeXVSaGFOR0dvZVExZm1kak12MEFPMmVcL1wveWVPUXJMT0RsODF3In0=
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.12.85.150]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> 
> Stephen Rothwell <sfr@canb.auug.org.au> writes:
> 
> > On Fri, 30 Nov 2018 12:05:55 +1100 Stephen Rothwell
> <sfr@canb.auug.org.au> wrote:
> >>
> >> After merging the wireless-drivers-next tree, today's linux-next
> >> build
> >> (x86_64 allmodconfig) produced these warnings:
> >>
> >> drivers/net/wireless/intel/iwlwifi/iwl-drv.c: In function
> 'iwl_parse_tlv_firmware':
> >> drivers/net/wireless/intel/iwlwifi/iwl-drv.c:1098:7: warning: this
> statement may fall through [-Wimplicit-fallthrough=]
> >>     if (iwlwifi_mod_params.enable_ini)
> >>        ^
> >> drivers/net/wireless/intel/iwlwifi/iwl-drv.c:1100:3: note: here
> >>    default:
> >>    ^~~~~~~
> >> drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c: In function
> 'iwl_parse_fw_dbg_tlv':
> >> drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c:203:4: warning: this
> statement may fall through [-Wimplicit-fallthrough=]
> >>     iwl_fw_dbg_copy_tlv(trans, tlv, true);
> >>     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >> drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c:204:3: note: here
> >>    default:
> >>    ^~~~~~~
> >>
> >> Introduced by commit
> >>
> >>   f14cda6f3b31 ("iwlwifi: trans: parse and store debug ini TLVs")
> >>
> >> These are noted because I use -Wimplict-fallthrough
> >>
> >> The warnings can be suppressed by adding a comment like
> >> 	/* fall through */
> >> at the appropriate place to indicate that the fallthough is intended.
> >
> > I am still seeing these warnings (but in the net-next tree now) and I
> > do not see a fix patch in the wireless-drivers-next tree.
> 
> Luca did submit a patch[1] for cfg80211 to fix those but I don't see any
> patches for iwlwifi (even in the one pending pull request he sent), not sure
> what happened. I know that Luca is already on holidays but adding
> Emmanuel, maybe he can help here?
> 

Just sent a patch.
