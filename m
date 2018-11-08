Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B0ACECDE47
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 22:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8FE720883
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 22:13:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="LQidVZaQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8FE720883
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731924AbeKIHvC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 02:51:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:43860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729099AbeKIHvC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 02:51:02 -0500
Received: from localhost (unknown [208.72.13.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52EBC2089F;
        Thu,  8 Nov 2018 22:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541715209;
        bh=Z0SBcwnNAaLQXyFr6g66A070xcRK4q32otkE+fxbegw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LQidVZaQswmjq6oIGLr21XC2Oj6YLaE9RZ3VoRJistjKOSNxM6qR6MXjRxMO3f2wX
         HnYMsxUgsqBvcdpnqfpa6mjAPxIrV/fqH+CP5j5VxdlNL6RjSApWZELwaEDAG8R703
         VfPl9fPYejixr4dbLHlvUp2vp7M/ugEg7R2NkOxs=
Date:   Thu, 8 Nov 2018 14:08:11 -0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adham.Abozaeid@microchip.com
Cc:     linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        adham.abozaeid@micochip.com, Ganesh.Krishna@microchip.com,
        Aditya.Shankar@microchip.com, johannes@sipsolutions.net
Subject: Re: [PATCH v4 1/3] staging: wilc1000: validate cfg parameters before
 scheduling the work
Message-ID: <20181108220811.GA15777@kroah.com>
References: <20181108214915.3733-1-adham.abozaeid@microchip.com>
 <20181108214915.3733-2-adham.abozaeid@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181108214915.3733-2-adham.abozaeid@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Nov 08, 2018 at 09:50:25PM +0000, Adham.Abozaeid@microchip.com wrote:
> From: Adham Abozaeid <adham.abozaeid@micochip.com>
> 
> From: Adham Abozaeid <adham.abozaeid@microchip.com>

Twice?  Something went wrong on your side, for all of these patches :(

Please fix up and resend.

thanks,

greg k-h
