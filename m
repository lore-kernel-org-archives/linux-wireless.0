Return-Path: <SRS0=+b/P=TQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40FC4C04AAF
	for <linux-wireless@archiver.kernel.org>; Thu, 16 May 2019 20:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08EE420848
	for <linux-wireless@archiver.kernel.org>; Thu, 16 May 2019 20:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558036895;
	bh=j28WNRxuKs/eVHJk8EWiLQ6sZGFMvN32tC2GoehiYQw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=P+KsWGydhA4+T7hPmrQ/xIUW9OfmNvAhYOSqmLSzo2ldC9PC9ZXiDLeglfSpinSzS
	 9w8RbraBSb6u9l3Dxr9du+jMtSW0W0EKZc3XAtMW54GjhaWBKvcsMTpykR/+rZwaj8
	 yQl9BCPPCl08B9yHON021hUYm3DIXlNF+Tr3aRGU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbfEPUBe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 May 2019 16:01:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726409AbfEPUBe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 May 2019 16:01:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D10FC20818;
        Thu, 16 May 2019 20:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558036893;
        bh=j28WNRxuKs/eVHJk8EWiLQ6sZGFMvN32tC2GoehiYQw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0PgbkkFHemtttpjYh7lH/5A1Rj5NoiBdelMo9OlKy9jLifWHCAjGL0YwhJRNV4HVX
         KawJBNGcrtdyV0D3PXlFzJ9CNdIImP2E334BJOI12NA9OLE+0KAcMpq0KccNHBlLzR
         i953/YdhopNKFZDJbzoNdW8BrbDkVjzIBH1C8SGc=
Date:   Thu, 16 May 2019 22:01:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/7] brcmsmac: switch source files to using SPDX license
 identifier
Message-ID: <20190516200131.GA15814@kroah.com>
References: <1558008251-13692-1-git-send-email-arend.vanspriel@broadcom.com>
 <1558008251-13692-4-git-send-email-arend.vanspriel@broadcom.com>
 <20190516173113.GA540@kroah.com>
 <a5d32b2f-a99b-a248-1acd-9de532732e30@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5d32b2f-a99b-a248-1acd-9de532732e30@broadcom.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, May 16, 2019 at 09:45:19PM +0200, Arend Van Spriel wrote:
> On 5/16/2019 7:31 PM, Greg Kroah-Hartman wrote:
> > On Thu, May 16, 2019 at 02:04:07PM +0200, Arend van Spriel wrote:
> > > With ISC license text in place under the LICENSES folder switch
> > > to using the SPDX license identifier to refer to the ISC license.
> > > 
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> > > Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> > > Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> > > Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> > > ---
> > > Hi Thomas, Greg,
> > > 
> > > The file drivers/net/wireless/broadcom/brcm80211/brcmsmac/led.c
> > > did not have license information nor copyright notice and as such
> > > it got included in commit b24413180f56 ("License cleanup: add SPDX
> > > GPL-2.0 license identifier to files with no license"). I added you
> > > guys as I propose to align this source file with the rest of
> > > the driver sources and change it to ISC license and add the missing
> > > copyright notice while at it (not sure if that warrants a separate
> > > patch).
> > 
> > A separate patch would be good, to make it explicit that you are
> > changing the license of the file.
> 
> Ok.
> 
> > And ISC, ick, why...  :)
> 
> Because the license text in the other driver source files is a 1:1 match
> with the ISC license.

Oh, I am not disagreeing with that, yes, that is obviously the license
of the files.  Just complaining about that choice for Linux kernel code :)

> Another option could be MIT license which is in the preferred folder.
> Will have to consult our legal department about it though.

Hey, if your legal department is going to get asked this, why not just
switch it to GPLv2?  That would make everything much simpler.

thanks,

greg k-h
