Return-Path: <SRS0=oA8K=4E=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D33C2BA83
	for <linux-wireless@archiver.kernel.org>; Sun, 16 Feb 2020 14:37:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9724120857
	for <linux-wireless@archiver.kernel.org>; Sun, 16 Feb 2020 14:37:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=newmedia-net.de header.i=@newmedia-net.de header.b="vpFcs00O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbgBPOgm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 16 Feb 2020 09:36:42 -0500
Received: from webmail.newmedia-net.de ([185.84.6.166]:45703 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbgBPOgm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Feb 2020 09:36:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=newmedia-net.de; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=lF1H11A4xL3IUsMYRIBxDsrUXUH8yfHXn7YDFVEYpQs=;
        b=vpFcs00O/dphvOFx2eCniSx05u8D+v4jVIs3g3mOshpFLrHI65h3kiI08FtKaq8fT/49YW+gu5hIAMYKTVKkwCWRhC4ZzeP1oVqxI6jwJUKW3UybxOFtottijJiPdsLDdoowPRwinE3httW0rgXRb1tfVagZmlr9PV4aldiRtxc=;
Subject: wireless regdb issue
To:     Seth Forshee <seth.forshee@canonical.com>
Cc:     wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
References: <1567189484-27536-1-git-send-email-hanipouspilot@gmail.com>
 <20191029144815.GR30813@ubuntu-xps13> <20200127042500.GE3730@ubuntu-xps13>
From:   Sebastian Gottschall <s.gottschall@newmedia-net.de>
Message-ID: <1c1bda62-fec8-b30d-5300-79fbe08fc517@newmedia-net.de>
Date:   Sun, 16 Feb 2020 15:36:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200127042500.GE3730@ubuntu-xps13>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Received:  from [2003:c9:3f10:df00:5ae:8058:a679:cdb8]
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@newmedia-net.de>)
        id 1j3Kzq-0006Rt-CU; Sun, 16 Feb 2020 15:34:10 +0100
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

i have found something very strange in the regdb. according to various 
sheets and document. channel 165 is not compatible with vht80
in the fcc area. but the regdb doesnt cover this rule. the whole range 
from 5735 - 5835 is set to vht80.

so what is correct?


Sebastian

