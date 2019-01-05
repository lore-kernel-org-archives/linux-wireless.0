Return-Path: <SRS0=nI2m=PN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C28C43612
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 20:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7240F213A2
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 20:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546721544;
	bh=nVfkmL6x+bRjUY0VM9nIIVb+loBP1W3P6geTENM0ZbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=w3Eb2pQp4gH/U12x9oLLTWG/ew9mLBaCmOhHc20HF8zMzNx9pHUiWepSY9b+jhiGN
	 /vRlQn5t054NMLlqmTsGB//e1X/X2WUzxDgR8HvQWdRXk8U+cFIO+8NyQC1oVIsNK8
	 G8KrH4KD8dF4azwlJ4VyAS4ZaqmtTLKji0gOBZUg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbfAEUwX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 15:52:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:48480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbfAEUwX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 15:52:23 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 913F820660;
        Sat,  5 Jan 2019 20:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546721542;
        bh=nVfkmL6x+bRjUY0VM9nIIVb+loBP1W3P6geTENM0ZbI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hXBLYJwZ/DQl8jEzTwsmpJtgkCynK4TiOkGbI/TG3rCMtkmXg9svp5Zda5MaWylY9
         uhTFLLtYD3J9pkph0aFDV7LuTeq4sc78JtGd4a1PoLR2c6Zg0wy3aReXGIdrNnu0Ig
         HQqY2RQAjJ3P7sWdhM1r8M66kLcLHlUrn13GmoZ8=
Date:   Sat, 5 Jan 2019 15:52:21 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Dietmar May <dmay@intellastar.com>
Cc:     stable@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: wlcore update breaks on 4.9 and 4.4 kernel branches
Message-ID: <20190105205221.GB166797@sasha-vm>
References: <43ee432a-c6ab-e23c-616c-b626a5fb4637@intellastar.com>
 <20181202150813.GG221015@sasha-vm>
 <72dcddb8-a44a-d50c-bae6-c51180e53cc8@intellastar.com>
 <20181212064051.GA2746@sasha-vm>
 <be76fc93-5bbc-9e00-3091-a57d13f2e485@intellastar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <be76fc93-5bbc-9e00-3091-a57d13f2e485@intellastar.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Jan 03, 2019 at 02:27:04PM -0500, Dietmar May wrote:
>Sasha,
>
>I've just confirmed that this problem is no longer present in 4.4.169 
>either, as expected.
>
>Sorry for the delay - we're on 4.9, so the 4.4 branch doesn't impact us.
>
>Just wanted to let you know so you have full closure on this issue.

Thank you for the update!

--
Thanks,
Sasha
