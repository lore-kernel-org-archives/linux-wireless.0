Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B1BC32792
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Aug 2022 19:34:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238826AbiHVTeH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238827AbiHVTdt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2022 15:33:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25808A18C
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2022 12:33:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAEBC6122B
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2022 19:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C73C433D6;
        Mon, 22 Aug 2022 19:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661196806;
        bh=SKJMBV4WC2IPslKcCXLmXfG2xzzPvwOl65256vjUqac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RCpHSQgE0uc/H1nTPfv0EJlkPgON2CfEe8WbK9MCHEN+/Cvo9GM+P2v9N/s3qFaTc
         RhOWdoGud0H81NRobsmLd6Ht64Q5G3fO1mCMKHGsQJC76cRzP5s6XXVykVt4Uhgz2b
         293NZpbu5LGYvExTRM3V/ZOy4kN5M0iCuAJcl8zA=
Date:   Mon, 22 Aug 2022 21:33:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Magal Baz <mbaz@fb.com>
Cc:     "aspriel@gmail.com" <aspriel@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "security@kernel.org" <security@kernel.org>
Subject: Re: Vulnerabilities in the brcmfmac driver
Message-ID: <YwPaASokqw0eunUj@kroah.com>
References: <97D835D2-29C5-4C86-8602-4C02C61DB28C@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97D835D2-29C5-4C86-8602-4C02C61DB28C@fb.com>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Aug 22, 2022 at 05:12:58PM +0000, Magal Baz wrote:
> 
> Please see the details in the attached PDF file.

For obvious reasons, we can't open unsolicited .pdf files, nor should
you ever put anything that should just be a normal text message, in that
for a kernel bug report :)

Also, as you sent this to public lists, no need to get
security@kernel.org involved, the normal bug report / fixup process can
happen here now.

thanks,

greg k-h
