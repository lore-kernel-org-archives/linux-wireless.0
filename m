Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5475FC433DB
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Feb 2021 18:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FE2764E54
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Feb 2021 18:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhB1S3B (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 28 Feb 2021 13:29:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:38864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229715AbhB1S3B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Feb 2021 13:29:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 924C764E54;
        Sun, 28 Feb 2021 18:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614536900;
        bh=kpuSgRv/YZfXQmzIPD2TW4JfWgOiHWHaWOt5osy0FlI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lHV7dXToYRyz58arVz8ysj9dxqxTDTDKyEsJoWHBm+OK1OH6eDfMCdg1XJ5twZa9W
         Jw5/N6Sv9gjgjuF/Z6WywE/M/TSR/Hj2C3ds5zfcPH0lGGe0pxDPY8iRzk+G+Dw0I2
         6BSsPdU4+Y0qH+zXT60Pt8css2Gx/v+plKvrHfG2s4LslIOHytEEZmz7Ltma0Q73ph
         VtFg7jz6mz9cpg7vKGnUb7NO+80KZszjCklgNGVGsvymCbWhSA84OPoJCqb+noqyk3
         iQzfGmZ/N56ab18P4IA5BCRX4w/I86xJrJZGDWFwGlwLmcNtGRU0mSePMPPf97WWjx
         NMm+15UCZUVTQ==
Date:   Sun, 28 Feb 2021 10:28:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt7601u: enable TDLS support
Message-ID: <20210228102819.6331f91c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8f9fd662cdbbb70ba896f1bea80e696b15011d3f.1614536496.git.lorenzo@kernel.org>
References: <8f9fd662cdbbb70ba896f1bea80e696b15011d3f.1614536496.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 28 Feb 2021 19:23:09 +0100 Lorenzo Bianconi wrote:
> Notify mac80211 the mt7601u chipset support 802.11 TDLS. The feature has
> been tested with a mt7610u peer.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Jakub Kicinski <kuba@kernel.org>
