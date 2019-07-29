Return-Path: <SRS0=PVbi=V2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B14A6C433FF
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Jul 2019 06:46:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E9D92073F
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Jul 2019 06:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfG2GqF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Jul 2019 02:46:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46838 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbfG2GqF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Jul 2019 02:46:05 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 457435945B;
        Mon, 29 Jul 2019 06:46:04 +0000 (UTC)
Received: from localhost (unknown [10.43.2.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA106600C0;
        Mon, 29 Jul 2019 06:46:03 +0000 (UTC)
Date:   Mon, 29 Jul 2019 08:46:01 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Masanari Iida <standby24x7@gmail.com>
Cc:     helmut.schaa@googlemail.com, kvalo@codeaurora.org,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] rt2800usb: Add new rt2800usb device PLANEX
 GW-USMicroN
Message-ID: <20190729064601.GA2066@redhat.com>
References: <20190728140742.3280-1-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190728140742.3280-1-standby24x7@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Mon, 29 Jul 2019 06:46:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Jul 28, 2019 at 11:07:42PM +0900, Masanari Iida wrote:
> This patch add a device ID for PLANEX GW-USMicroN.
> Without this patch, I had to echo the device IDs in order to
> recognize the device.
> 
> # lsusb |grep PLANEX
> Bus 002 Device 005: ID 2019:ed14 PLANEX GW-USMicroN
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
