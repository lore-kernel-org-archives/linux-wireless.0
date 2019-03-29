Return-Path: <SRS0=IiY2=SA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2EE0C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Mar 2019 13:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB34B217F5
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Mar 2019 13:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729630AbfC2N0L (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 Mar 2019 09:26:11 -0400
Received: from webmail2.dei.unipd.it ([147.162.2.99]:60684 "HELO
        mail.dei.unipd.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with SMTP id S1729614AbfC2N0L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Mar 2019 09:26:11 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.dei.unipd.it (Postfix) with ESMTP id 70E7C400B0
        for <linux-wireless@vger.kernel.org>; Fri, 29 Mar 2019 14:26:09 +0100 (CET)
X-Virus-Scanned: amavisd-new at dei.unipd.it
Received: from mail.dei.unipd.it ([127.0.0.1])
        by localhost (mail.dei.unipd.it [127.0.0.1]) (amavisd-new, port 10024)
        with SMTP id 0I_vau06tnVo for <linux-wireless@vger.kernel.org>;
        Fri, 29 Mar 2019 14:26:07 +0100 (CET)
Received: from webmail2 (localhost.localdomain [127.0.0.1])
        by mail.dei.unipd.it (Postfix) with ESMTP id 5C838400A0
        for <linux-wireless@vger.kernel.org>; Fri, 29 Mar 2019 14:26:07 +0100 (CET)
Received: from pcrossi1.dei.unipd.it (pcrossi1.dei.unipd.it [147.162.97.9])
 by mail.dei.unipd.it (Horde Framework) with HTTPS; Fri, 29 Mar 2019 14:26:07
 +0100
Date:   Fri, 29 Mar 2019 14:26:07 +0100
Message-ID: <20190329142607.Horde.d3GknYZ2mQFG07_UafOtL62@mail.dei.unipd.it>
From:   meneghello@dei.unipd.it
To:     linux-wireless@vger.kernel.org
Subject: wil6210 new features support
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


Good morning,

we are working on OpenWrt support for wil6210 driver.
We are interest in support for new features like radar.
Is there any chance that this feature will be implemented in the next  
version of the firmware?
In case it is, can you share with us a beta version to do some testing?

Thank you.

Francesca Meneghello & Jacopo Pegoraro

