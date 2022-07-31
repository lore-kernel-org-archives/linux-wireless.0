Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA6DFC19F2B
	for <linux-wireless@archiver.kernel.org>; Sun, 31 Jul 2022 15:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237461AbiGaP4u (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 31 Jul 2022 11:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbiGaP4u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 31 Jul 2022 11:56:50 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050:0:465::101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A23F5B8;
        Sun, 31 Jul 2022 08:56:48 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4Lwm8Y3mDpz9sQw;
        Sun, 31 Jul 2022 17:56:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1659283005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=YL8tRzwbOzLIHMrdZAVR9abCUBhVs9KYCSZtMX+wHc0=;
        b=YHwzAN74nmHhsHmxIpiEbygHFTb9UIJr8HxCxjSo9+Ga2XIfWTjGKTpnoVaveSAdfWh/io
        6cy0DoJ+mbhmcHZxNu4npgx/h2f1V4V8byj8o65PDP5PqATZnjlIhdakgzUkVzCJ7+yTIh
        X7hIZReowAUKUmu5NVjWzRyWzRMjp4E9CUVI2QrpZZuhFqSbFXMBpCL8LoEbPsCfcL1Gr0
        ArNT8x6acEFSMuQGamqfTWmgTFC03nm8RlMjiiGxEp+zTghqnS+P1oOlIt2zmwAmFIXCff
        saR45wzXjt6WR0LB8G4QUDo9sOKxGB7f81LQa7yij02RkBfaVkF1cjM1Yul9dg==
Message-ID: <df65214c-d26a-5b71-2b3d-2ce8ba60bdbd@hauke-m.de>
Date:   Sun, 31 Jul 2022 17:56:44 +0200
MIME-Version: 1.0
Content-Language: en-US
To:     "backports@vger.kernel.org" <backports@vger.kernel.org>
Cc:     linux-wireless@vger.kernel.org
From:   Hauke Mehrtens <hauke@hauke-m.de>
Subject: wireless backports 5.15.58-1 released
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4Lwm8Y3mDpz9sQw
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi

backports-5.15.58-1 was released. This is based on Linux 5.15.58.
https://cdn.kernel.org/pub/linux/kernel/projects/backports/stable/v5.15.58/backports-5.15.58-1.tar.xz

There is now a updated wiki page with the releases:
https://backports.wiki.kernel.org/index.php/Releases

The source code can be found here:
https://git.kernel.org/cgit/linux/kernel/git/backports/backports.git/

Hauke
