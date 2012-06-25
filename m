Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:48012 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755621Ab2FYKIl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 06:08:41 -0400
Received: by lbok6 with SMTP id k6so7210222lbo.4
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2012 03:08:39 -0700 (PDT)
Message-ID: <1340618917.1631.467.camel@cumari.coelho.fi> (sfid-20120625_120847_201914_1EFC18C1)
Subject: Re: pull request: TI wireless drivers 2012-06-24 (for 3.6)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, arik@wizery.com, assaf@ti.com
Date: Mon, 25 Jun 2012 13:08:37 +0300
In-Reply-To: <1340527191.1631.423.camel@cumari.coelho.fi>
References: <1340527191.1631.423.camel@cumari.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Sun, 2012-06-24 at 11:39 +0300, Luciano Coelho wrote:
> Hi John,
> 
> One more pull request intended for 3.6.  Mostly about SDIO error
> handling (by Ido) and correct handling and recovery during
> suspend/resume.  Plus one new debugfs entry that allows easier FW
> debugging, by Arkady.
> 
> Please pull or let me know if there's any problem.

Please hold on with this pull request.  We have found a serious bug and
will fix it.  I'll send a v2 later today.

Thanks!

--
Luca.

