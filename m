Return-Path: <SRS0=FjVT=OO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F95EC04EB9
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 19:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2F1D20892
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 19:38:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D2F1D20892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=davemloft.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbeLETit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Dec 2018 14:38:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43068 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbeLETir (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Dec 2018 14:38:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::bf5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E197814525CDA;
        Wed,  5 Dec 2018 11:38:43 -0800 (PST)
Date:   Wed, 05 Dec 2018 11:38:43 -0800 (PST)
Message-Id: <20181205.113843.1342804787283427751.davem@davemloft.net>
To:     petrm@mellanox.com
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, devel@linuxdriverproject.org,
        linux-wireless@vger.kernel.org, linux-s390@vger.kernel.org,
        devel@driverdev.osuosl.org, sparmaintainer@unisys.com,
        linux-bluetooth@vger.kernel.org, dev@openvswitch.org,
        linux-kselftest@vger.kernel.org, dledford@redhat.com, jgg@ziepe.ca,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        benve@cisco.com, _govind@gmx.com, pkaustub@cisco.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        linux-net-drivers@solarflare.com, ecree@solarflare.com,
        bkenward@solarflare.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, jiri@resnulli.us,
        dsa@cumulusnetworks.com, shrijeet@gmail.com, j@w1.fi,
        kvalo@codeaurora.org, jwi@linux.ibm.com, ubraun@linux.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        ruxandra.radulescu@nxp.com, ioana.ciornei@nxp.com,
        gregkh@linuxfoundation.org, david.kershner@unisys.com,
        marcel@holtmann.org, johan.hedberg@gmail.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net-next 0/8] Pass extack to NETDEV_PRE_UP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1544006963.git.petrm@mellanox.com>
References: <cover.1544006963.git.petrm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Dec 2018 11:38:45 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


Your CC list is so huge that vger.kernel.org dropped all of your postings.

That CC list is not reasonable at all, trim it down to the most minimum
set.  Probably 2 or 3 mailing lists, primarily netdev, and maybe a small
handful of specific developers.

Nothing more.
