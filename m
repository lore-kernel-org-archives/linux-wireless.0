Return-Path: <SRS0=+b/P=TQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06392C04AAF
	for <linux-wireless@archiver.kernel.org>; Thu, 16 May 2019 17:31:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7EB120833
	for <linux-wireless@archiver.kernel.org>; Thu, 16 May 2019 17:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558027877;
	bh=f1ON+82/F3DXvbbnXS03tpeiges3G7FLV8YMGZogVMg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Y2sfeaFDsf4oieLdR6y5jNhi623EXYOrtlYzBbIpGjRD5K+T716MadGUYXPp5n+RX
	 C0MsJf2GgnSf1WiDxT83swR74CFnE7Epcj6OX3RhPC+SCFBcoZmUS1GRbisa6cb9rm
	 ao2Tp4WetvYBByHhItVuqv79/K8r8lfJur0abQbM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbfEPRbR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 May 2019 13:31:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726409AbfEPRbQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 May 2019 13:31:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D09F12082E;
        Thu, 16 May 2019 17:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558027876;
        bh=f1ON+82/F3DXvbbnXS03tpeiges3G7FLV8YMGZogVMg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VJldWsNcPNJnlFDpM+671bvKuo63jpPtISyoK0+HAIwL+P8R/Pfxb39sa9Me87O9+
         QL/WQIzNxM4TgFukDn9DJu0Qw3Dt/fWUh8EcSTRLGpgbUh4aTEN5+RtT5EiZBcVfz4
         BcuzUry2Y7A+lFaScOAwnCe5kGHIeLWZ3lSKvstY=
Date:   Thu, 16 May 2019 19:31:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/7] brcmsmac: switch source files to using SPDX license
 identifier
Message-ID: <20190516173113.GA540@kroah.com>
References: <1558008251-13692-1-git-send-email-arend.vanspriel@broadcom.com>
 <1558008251-13692-4-git-send-email-arend.vanspriel@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558008251-13692-4-git-send-email-arend.vanspriel@broadcom.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, May 16, 2019 at 02:04:07PM +0200, Arend van Spriel wrote:
> With ISC license text in place under the LICENSES folder switch
> to using the SPDX license identifier to refer to the ISC license.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
> Hi Thomas, Greg,
> 
> The file drivers/net/wireless/broadcom/brcm80211/brcmsmac/led.c
> did not have license information nor copyright notice and as such
> it got included in commit b24413180f56 ("License cleanup: add SPDX
> GPL-2.0 license identifier to files with no license"). I added you
> guys as I propose to align this source file with the rest of
> the driver sources and change it to ISC license and add the missing
> copyright notice while at it (not sure if that warrants a separate
> patch).

A separate patch would be good, to make it explicit that you are
changing the license of the file.

And ISC, ick, why...  :)

thanks,

greg k-h
