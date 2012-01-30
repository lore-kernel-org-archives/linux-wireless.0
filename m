Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:52382 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751777Ab2A3Tsn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 14:48:43 -0500
Received: by mail-lpp01m010-f49.google.com with SMTP id r15so3684727lag.22
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 11:48:41 -0800 (PST)
Subject: Re: [PATCH 06/12] wl12xx: Driver-FW API changes
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1327924857-1250-7-git-send-email-eliad@wizery.com>
References: <1327924857-1250-1-git-send-email-eliad@wizery.com>
	 <1327924857-1250-7-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Jan 2012 21:48:38 +0200
Message-ID: <1327952918.3626.106.camel@cumari> (sfid-20120130_204845_436684_305CF3B9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-01-30 at 14:00 +0200, Eliad Peller wrote: 
> From: Eyal Shapira <eyal@wizery.com>
> 
> - New ACX enum
> - Added DFS commands
> - Changes to channel switch command/event
> - Added reset_tsf to ap role start command
> - Added ACX for PROTECTION configuration
> 
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

I think this shold also be squashed with the previous one.  Especially
because this commit log says it does things that were actually already
done in the previous one. ;)


-- 
Cheers,
Luca.

