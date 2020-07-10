Return-Path: <SRS0=HO9U=AV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38853C433E4
	for <linux-wireless@archiver.kernel.org>; Fri, 10 Jul 2020 20:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CAFF2075D
	for <linux-wireless@archiver.kernel.org>; Fri, 10 Jul 2020 20:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594411229;
	bh=P3wpcTeRzR1W7CsDV4CKETpMMwO9CpwhiI6JROxgy/c=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=DKK9rtpWbqMfrVPoDKecWYm9Ov1T8vci9r7fJVQH7y8mT41MdnTvF52vaKsW//gVo
	 /k34BM4oaljLViDTYuzyhRnLXXVqrAXLcMyZBNqYc9g1aSQ/qjIfYo/P5f6vtKE1qL
	 SadUIEr33uLwASb2cUwDBBCNGR6mUlxn+eavXKzI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgGJUA2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 10 Jul 2020 16:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbgGJUA1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Jul 2020 16:00:27 -0400
Received: from localhost (mobile-166-175-191-139.mycingular.net [166.175.191.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 220E22075D;
        Fri, 10 Jul 2020 20:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594411227;
        bh=P3wpcTeRzR1W7CsDV4CKETpMMwO9CpwhiI6JROxgy/c=;
        h=Date:From:To:Cc:Subject:From;
        b=hdeT8rrYYu/udjXGyQJF+Gm/hBBwY75ykez1Hzps7vAkXzgbjHH0FEqIdOHNmZjR2
         M7+kYkgeWzvnSO9YIEOb+yPh4hBSrwPOcfUuI8VS+vssHLp6OMdMSrQQ7+8LBwC3Bn
         QJXh7c/Bt1cGCcR1O6PaQoS7+YSzK8gwbpLP6bCA=
Date:   Fri, 10 Jul 2020 15:00:25 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Add ath9k-devel archives to lore?
Message-ID: <20200710200025.GA75493@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The ath9k-devel mailing list was closed in 2017 in favor of
linux-wireless (per
https://wireless.wiki.kernel.org/en/users/Drivers/ath9k), but the
archives contain information that may still be useful.

For instance, Pali just sent me a link
(https://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg07529.html)
about an issue with PCI enumeration.

The ath9k-devel archive still seems to exist at
https://lists.ath9k.org/pipermail/ath9k-devel/ and
https://www.mail-archive.com/ath9k-devel@lists.ath9k.org/

https://korg.docs.kernel.org/lore.html says pipermail archives *can*
be used, but it's better to start with something else.  

Is anybody interested in adding the ath9k-devel archives to lore?  If
so, does anybody have an archive to start with?

Bjorn
