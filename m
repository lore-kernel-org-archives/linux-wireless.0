Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 744EEC636D4
	for <linux-wireless@archiver.kernel.org>; Mon, 13 Feb 2023 15:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbjBMPDi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 13 Feb 2023 10:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbjBMPDb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Feb 2023 10:03:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCE71DB90
        for <linux-wireless@vger.kernel.org>; Mon, 13 Feb 2023 07:03:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F00496111D
        for <linux-wireless@vger.kernel.org>; Mon, 13 Feb 2023 15:03:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4567FC4339B;
        Mon, 13 Feb 2023 15:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676300598;
        bh=+wHNNUbH6IacyvhR0YG0p1wvBG2pNhi5O0ky4wI6F/k=;
        h=Date:From:To:Cc:Subject:From;
        b=SBXo2NMq5NFdJU9rPiiAQ4ysm0+M437fuIcd9MdSA1kTc/9ipuhHK/ztE0VO1uEwu
         y6djrgeF/w6jOpbpAoTILxku7wq6iCqOmzPaTL94u10uopXtH6ldghiIDAgt7qkwrC
         K/gKEit9LePign373i05JqFnoqpGqJnToTeoWQr7DIwjgTAltp/wrKlPlbEyKXVy/b
         /EP1XtT+4h+f6OCGVEaSOTM8aF1zRiCXQpEy1zrziDMIv5aEvpP6UIOuKPlHyoa1zV
         34VgDy2X5gqaSqnH40xj4duHT3JrVqD2synObzbP0Cn+JPuOSiMEAotqymtdnIAns1
         +tWjTQ0Jzp8Pg==
Date:   Mon, 13 Feb 2023 09:03:17 -0600
From:   Seth Forshee <sforshee@kernel.org>
To:     wireless-regdb@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [wireless-regdb] [ANN] wireless-regdb: master-2023-02-13
Message-ID: <Y+pRNR9Zl+vqiJQo@ubuntu-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

A new release of wireless-regdb (master-2023-02-13) is available at:

https://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-2023.02.13.tar.xz

The short log of changes since the master-2022-08-12 release is below.

Thanks,
Seth

---

CaffeeLake (2):
      wireless-regdb: Update regulatory rules for Japan (JP) on 5GHz
      wireless-regdb: Update regulatory rules for Japan (JP) on 6GHz

Cesar Eduardo Barros (1):
      wireless-regdb: Update regulatory rules for Brazil (BR)

Eugene Konev (1):
      wireless-regdb: Update regulatory info for Russia (RU) on 5GHz

Lorenz Brun (1):
      wireless-regdb: update regulatory rules for Switzerland (CH)

Seth Forshee (1):
      wireless-regdb: update regulatory database based on preceding changes

