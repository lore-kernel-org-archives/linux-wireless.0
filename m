Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A21E6C433ED
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Apr 2021 04:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 534B661004
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Apr 2021 04:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234841AbhDUEwc convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Apr 2021 00:52:32 -0400
Received: from smtp6.ctinetworks.com ([205.166.61.199]:56960 "EHLO
        smtp6.ctinetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbhDUEwb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Apr 2021 00:52:31 -0400
Received: from localhost (unknown [117.254.35.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: enometh@meer.net)
        by smtp6.ctinetworks.com (Postfix) with ESMTPSA id 6A89E80AB5
        for <linux-wireless@vger.kernel.org>; Wed, 21 Apr 2021 00:51:53 -0400 (EDT)
Date:   Wed, 21 Apr 2021 10:21:30 +0530 (IST)
Message-Id: <20210421.102130.167565230547376402.enometh@meer.net>
To:     linux-wireless@vger.kernel.org
Subject: Re: rtw88 strange killall behaviour with nm
From:   Madhu <enometh@meer.net>
In-Reply-To: <9167fd6d-affa-21d5-bd8d-0fb3d49d38f0@justmail.de>
 ("Klaus=?iso-8859-1?Q?=0A=09M=FCller"'s?= message of "Tue, 20 Apr 2021
 06:34:56 +0200")
References: <20210420.063244.1157699536418751229.enometh@meer.net>
        <9167fd6d-affa-21d5-bd8d-0fb3d49d38f0@justmail.de>
X-Mailer: Mew version 6.8 on Emacs 28.0
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-ctinetworks-Information: Please contact the ISP for more information
X-ctinetworks-MailScanner-ID: 6A89E80AB5.A91CB
X-ctinetworks-VirusCheck: Found to be clean
X-ctinetworks-SpamCheck: 
X-ctinetworks-Watermark: 1619844718.07519@EZX6dfqnccx2dkgtt3MfTg
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

* Klaus Müller <9167fd6d-affa-21d5-bd8d-0fb3d49d38f0@justmail.de> :
Wrote on Tue, 20 Apr 2021 06:34:56 +0200:
> Did you try https://github.com/lwfinger/rtw88

Yes, after the first time it happened (with the stock 5.10.30 kernel)
I updated the rtw88 firmware from git, it happened again. Then i used
the modules from the above location (which also match the git
firmware), and the behaviour persists.
