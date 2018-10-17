Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A6F0ECDE32
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 08:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39A4D2151D
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 08:11:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 39A4D2151D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbeJQQGQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 12:06:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18311 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726967AbeJQQGQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 12:06:16 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A843949020;
        Wed, 17 Oct 2018 08:11:45 +0000 (UTC)
Received: from localhost (unknown [10.43.2.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CD375C225;
        Wed, 17 Oct 2018 08:11:41 +0000 (UTC)
Date:   Wed, 17 Oct 2018 10:11:32 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [RFC 4/9] mt76x0: pci: add pre_tbtt_tasklet support
Message-ID: <20181017081131.GB2256@redhat.com>
References: <cover.1539723134.git.lorenzo.bianconi@redhat.com>
 <a9a57f93166d917d7682b4a201351f526155cd1e.1539723134.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9a57f93166d917d7682b4a201351f526155cd1e.1539723134.git.lorenzo.bianconi@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Wed, 17 Oct 2018 08:11:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Oct 16, 2018 at 11:23:26PM +0200, Lorenzo Bianconi wrote:
> Enable/disable pre_tbtt_tasklet in mt76x0 driver in order
> to add AP support

Is there some USB limitation that disallow tho do this for USB
as well? Or perhaps this is easer for now do this for PCI devices
and add AP support for USB later? But perhaps, since you adding
support for AP you could do this for both buses.

Thanks
Stanislaw 
