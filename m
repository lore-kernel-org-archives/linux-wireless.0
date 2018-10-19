Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCE42ECDE43
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 09:15:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 906AF21477
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 09:15:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 906AF21477
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbeJSRVK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 13:21:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36339 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbeJSRVK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 13:21:10 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9CB33300441E;
        Fri, 19 Oct 2018 09:15:57 +0000 (UTC)
Received: from localhost (unknown [10.43.2.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B4A56A75F;
        Fri, 19 Oct 2018 09:15:52 +0000 (UTC)
Date:   Fri, 19 Oct 2018 11:15:51 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-mediatek@lists.infradead.org
Cc:     sean.wang@mediatek.com, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: MT7630E firmware and Mediatek support
Message-ID: <20181019091550.GA7360@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 19 Oct 2018 09:15:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello MediaTek

I plan to submit this firmware to linux-firwmare git tree:
https://github.com/neurobin/MT7630E/tree/release/firmware/Wi-FI
to add support for MT7630E with mt76/mt76x0 driver, is this ok ?

I would also ask if Mediatek can provide some support for us
to have their WiFi products working better with mainline linux?

Some example things that Mediatek could do that come in mind
and I would like to request are:

- Testing and reviewing our patches.
- Assign support engineer for us who could answer questions about
  low level configuration and help solving problems.
- Financing to Felix for doing maintainace and development work of
  mt76 driver.
- Provide newer/better version of Mediatek driver/SDK for reference.
- Provide hardware not yet released on the market for adding
  support for new chips.
- Provide documentation.

If any of that could be done by Mediatek would be great.

You can answer me off-list, if you prefer that.

Thanks
Stanislaw
