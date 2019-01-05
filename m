Return-Path: <SRS0=nI2m=PN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC40BC43387
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 08:53:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9883721871
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 08:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546678385;
	bh=0vOrMLxWXxLlBua5CYnXBzPeXC2mex9gN8/WWotnZwg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=okFttRq6zMIC4raXUdAFzI+LQKoJmo8vwIQrEVWpy7PKhajwJGGLRpIqrzSyISZj0
	 yzL2Z9tPIuPjkisfHUOlapK4unHnKDN3E75cOkSXsUc0zHZXO5vxyhDblZ2J9LD58O
	 AFIMyy/WGCI6BzCLnVHy7G7hoGYwGTXPKN/oV7HY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfAEIxC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 03:53:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:58196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbfAEIxC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 03:53:02 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE90E20874;
        Sat,  5 Jan 2019 08:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546678381;
        bh=0vOrMLxWXxLlBua5CYnXBzPeXC2mex9gN8/WWotnZwg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kfK1MBujlZxKAjxe+0AyVdTGCTHSY1N7ukAzAT1rn3v+t/4HDzY1opG4XrzBbKVEi
         9f52/LtfW78K+Prpfu4z4/tRBVZcN2YxbLjCvI2nNUv7ZE0gd4sogcRYa8LqhWg07M
         L/dBbGsW1PiVuYy45VbUwAsBsp8jl6ltRyzdQ64g=
Date:   Sat, 5 Jan 2019 09:52:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?J=FAlius?= Milan <jmilan.dev@gmail.com>
Cc:     =?iso-8859-1?Q?J=FAlius?= Milan <julikmilan@gmail.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, ajay.kathat@microchip.com,
        adham.abozaeid@microchip.com
Subject: Re: [PATCH] staging: wilc1000: fix cast to restricted __le32
Message-ID: <20190105085258.GA13941@kroah.com>
References: <20190105082323.GA27838@localhost.localdomain>
 <CAP=P++A1LritztQ1=fHOE7XXJN_0TvNHEjh7tVrpDj1kYFrNTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP=P++A1LritztQ1=fHOE7XXJN_0TvNHEjh7tVrpDj1kYFrNTQ@mail.gmail.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Jan 05, 2019 at 09:32:56AM +0100, Július Milan wrote:
> sorry, bad mail, see the next one please

Properly version your patches so I know what "next one" really means.

I've dropped all of these patches from my queue now, please resend with
a v2 added to the patch as the documentation says to do.

thanks,

greg k-h
