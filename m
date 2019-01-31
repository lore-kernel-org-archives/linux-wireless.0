Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87174C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 19:29:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 630FB218EA
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 19:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbfAaT3Z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 14:29:25 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:55304 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727161AbfAaT3Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 14:29:24 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gpI1a-0000px-Ty; Thu, 31 Jan 2019 20:29:23 +0100
Message-ID: <5e04d03f8f7cd65073215f395e40fdc2af0a7704.camel@sipsolutions.net>
Subject: Re: Wi-Fi drivers/chipsets supporting 802.11w / PMF / MFP
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Raul Siles <raul.siles@gmail.com>, Rosen Penev <rosenp@gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Date:   Thu, 31 Jan 2019 20:29:20 +0100
In-Reply-To: <CANP28d25-VKjsxtd423JQJqdYiyPs9WUU6AKc6qeLsO=02CJCQ@mail.gmail.com> (sfid-20190129_183135_821656_1D2F71E4)
References: <CANP28d09JUQRB-iCBAGgkzv3zZ6k+irNB3uMYW3teN5xLX-eWw@mail.gmail.com>
         <CAKxU2N87ghf5kFoUN1Ru57SNoyV=S=-NUpaPP6LTSgvAu_nscA@mail.gmail.com>
         <CANP28d25-VKjsxtd423JQJqdYiyPs9WUU6AKc6qeLsO=02CJCQ@mail.gmail.com>
         (sfid-20190129_183135_821656_1D2F71E4)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-01-29 at 18:31 +0100, Raul Siles wrote:
> Hi Rosen,
> Thanks for the reference! It is, indeed, a great and accurate way of
> keeping track of Linux drivers that are MFP_CAPABLE (Wi-Fi PMF, MFP,
> 802.11w).

Note that this is only true for mac80211-based drivers.

For the others, you'll want to check if their cipher list mentions
WLAN_CIPHER_SUITE_AES_CMAC.

johannes

