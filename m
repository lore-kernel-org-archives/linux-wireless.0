Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5CB5C04A6A
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Aug 2023 14:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbjHIOFn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Aug 2023 10:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233110AbjHIOFm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2023 10:05:42 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 2CD6C2106
        for <linux-wireless@vger.kernel.org>; Wed,  9 Aug 2023 07:05:41 -0700 (PDT)
Received: (qmail 197404 invoked by uid 1000); 9 Aug 2023 10:05:40 -0400
Date:   Wed, 9 Aug 2023 10:05:40 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     USB mailing list <linux-usb@vger.kernel.org>,
        linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Fix nomenclature for USB and PCI wireless devices
Message-ID: <cce342f1-55b9-49ba-81a9-cc9e83735ff9@rowland.harvard.edu>
References: <57da7c80-0e48-41b5-8427-884a02648f55@rowland.harvard.edu>
 <2023080940-overhand-fondly-7ef7@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023080940-overhand-fondly-7ef7@gregkh>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Aug 09, 2023 at 02:16:48PM +0200, Greg KH wrote:
> On Tue, Aug 08, 2023 at 08:44:48PM -0400, Alan Stern wrote:
> > A mouse that uses a USB connection is called a "USB mouse" device (or
> > "USB mouse" for short), not a "mouse USB" device.  By analogy, a WiFi
> > adapter that connects to the host computer via USB is a "USB wireless"
> > device, not a "wireless USB" device.  (The latter term more properly
> > refers to a defunct Wireless USB specification, which described a
> > technology for sending USB protocol messages over an ultra wideband
> > radio link.)
> > 
> > Similarly for a WiFi adapter card that plugs into a PCIe slot: It is a
> > "PCIe wireless" device, not a "wireless PCIe" device.
> > 
> > Rephrase the text in the kernel source where the word ordering is
> > wrong.
> > 
> > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Can you accept this patch, or should I ask Johannes Berg or Kalle Valo 
to merge it through the wireless subsystem?

Alan Stern
