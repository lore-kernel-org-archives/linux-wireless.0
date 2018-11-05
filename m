Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EACBC0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 14:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3559220866
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 14:16:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="pBPsoQQ3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3559220866
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbeKEXgJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 18:36:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:37064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727481AbeKEXgJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 18:36:09 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED43620862;
        Mon,  5 Nov 2018 14:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541427373;
        bh=5VPjcJxCVLfYUiVV2rdWY9fxtSWtzQyVarlcrZ/SM7U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pBPsoQQ3HMWSmiedmmkuZUcUdnjIdy0frLRmS3VOs9RVm1aKe8MeQKbSS5aMDIy2Q
         u29R6jkWmY2bY3FmLANPGd4AqkNziiYtbe24XvkRht7JgvdDPq24p7/ITtpGZt1ZnO
         vXH0mt4UAMdZp8rHlDaX8V6hZmggpQJucsqHH8PQ=
Date:   Mon, 5 Nov 2018 15:16:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ajay.Kathat@microchip.com
Cc:     linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Ganesh.Krishna@microchip.com, Adham.Abozaeid@microchip.com,
        Aditya.Shankar@microchip.com, johannes@sipsolutions.net
Subject: Re: [PATCH] staging: wilc1000: update wilc1000 driver maintainer ids
Message-ID: <20181105141611.GA21485@kroah.com>
References: <1540878731-7326-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540878731-7326-1-git-send-email-ajay.kathat@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Oct 30, 2018 at 05:53:40AM +0000, Ajay.Kathat@microchip.com wrote:
> From: Ajay Singh <ajay.kathat@microchip.com>
> 
> We would like to update the maintainer email id's for wilc1000 driver.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>

It would be good to get the current maintainer's signed off by on this
so I know that they also agree with this change.

thanks,

greg k-h
