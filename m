Return-Path: <SRS0=0pA5=NS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4445BC0044C
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 09:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3F2E2086B
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 09:14:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="IDKAxlQ4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F3F2E2086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbeKGSnd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Nov 2018 13:43:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:57868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbeKGSnd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Nov 2018 13:43:33 -0500
Received: from localhost (unknown [104.153.224.168])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F58A20827;
        Wed,  7 Nov 2018 09:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541582045;
        bh=Dc+L66RGfDMYRdX9Pa6r74xYnJd4PGka2idot385YBM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IDKAxlQ4qxKSFJEgmy2ccZX4wrQM2VKEz/RSo8L2aJnWRxgEmt9FwNb1/7zYksUau
         OwItXt9NDXYCd3E6GyUlBtBhyfENQpLm+CMuz/kajfq8nMhMhPYEY8fBMz/0hX2d01
         H4OBSbcxhFO2S1mzjF9gzqbY9FOLUgoU61x5YwNU=
Date:   Wed, 7 Nov 2018 10:13:56 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ajay.Kathat@microchip.com
Cc:     linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Ganesh.Krishna@microchip.com, Adham.Abozaeid@microchip.com,
        Aditya.Shankar@microchip.com, johannes@sipsolutions.net
Subject: Re: [PATCH v2] staging: wilc1000: update wilc1000 driver maintainer
 ids
Message-ID: <20181107091356.GC31015@kroah.com>
References: <1541567062-5793-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541567062-5793-1-git-send-email-ajay.kathat@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Nov 07, 2018 at 05:05:01AM +0000, Ajay.Kathat@microchip.com wrote:
> From: Ajay Singh <ajay.kathat@microchip.com>
> 
> We would like to update the maintainer email id's for wilc1000 driver.
> 
> Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
> Signed-off-by: Ganesh Krishna <ganesh.krishna@microchip.com>
> Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>

Not that I do not trust you, but I would really like to see an email
directly from the existing maintainers that they did sign off on this or
at least ack it.

thanks,

greg k-h
