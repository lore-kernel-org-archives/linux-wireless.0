Return-Path: <SRS0=6Pxi=7L=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16206C433E0
	for <linux-wireless@archiver.kernel.org>; Fri, 29 May 2020 08:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E929E207BC
	for <linux-wireless@archiver.kernel.org>; Fri, 29 May 2020 08:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590742542;
	bh=zDPyiYau/GuyIfR6tLiVFlkacXVXkEPMUpHP5Uo7uVo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ANgi53YeG9hC2ZVaueg7NWpIjl9ExY+0/wOE7pwBw3Z9ucX7WXOCJnOLaNE0T7JrJ
	 9EbPE1ZmbRBfeg75txvJw+ffGk0sB3veY5i9LkvDtpT4uQ91IN6kBCxYkLppp8zLEI
	 aHERU8Bay+WrkBPsWuZk57U5sDklAq2aGa1CwDQA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgE2Izj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 May 2020 04:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgE2Izj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 May 2020 04:55:39 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEE13205CB;
        Fri, 29 May 2020 08:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590742539;
        bh=zDPyiYau/GuyIfR6tLiVFlkacXVXkEPMUpHP5Uo7uVo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IdZ3e21EQo+aM5HIBDDyV/UNWn85XBHr7JlaFyae37yhkvWY+wxu1dOyE4U6APbYV
         8IGV+27eJhkWJ6sikxmO58s6n0CK8uaWRkr9DozDAB1fpaYplMsqEazM6r+YLXMhLP
         CbKztxTuGXeosRLOKWuK7ue3KxfoGBl5vW5Q2g6I=
Received: by pali.im (Postfix)
        id 09713EB1; Fri, 29 May 2020 10:55:36 +0200 (CEST)
Date:   Fri, 29 May 2020 10:55:36 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Ganapathi Bhat <ganapathi.bhat@nxp.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Marek =?utf-8?B?QmVow7pu?= <marek.behun@nic.cz>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] mwifiex: Firmware name for W8997 sdio wifi chip
Message-ID: <20200529085536.zivf36mn2d6zx5ii@pali>
References: <20200515132353.vfor7v4buzoddfmb@pali>
 <VI1PR04MB4366625917BB57695BE454448FBA0@VI1PR04MB4366.eurprd04.prod.outlook.com>
 <20200528103432.irmsaaz72x3xophg@pali>
 <VI1PR04MB4366409B8E293A265851DA948F8F0@VI1PR04MB4366.eurprd04.prod.outlook.com>
 <20200529084630.j7rpdypt6vycsedh@pali>
 <VI1PR04MB4366DECFA1EB5C3D6AADB0818F8F0@VI1PR04MB4366.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB4366DECFA1EB5C3D6AADB0818F8F0@VI1PR04MB4366.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Friday 29 May 2020 08:49:18 Ganapathi Bhat wrote:
> Hi Pali,
>  
> > Hello Ganapathi! Thank you for information. Can you point me to git tree or
> > location where are firmware files already updated?
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
> 
> or
> 
> https://github.com/NXP/mwifiex-firmware

Hello Ganapathi! Seems that on both locations is older version of
sdsd8997_combo_v4.bin firmware, not the latest one. On both location is
available just version 16.68.1.p179. But we have newer version
16.68.1.p197. Could you please recheck it?
