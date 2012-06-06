Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:49050 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634Ab2FFRG7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 13:06:59 -0400
Received: by lbon10 with SMTP id n10so5343235lbo.41
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 10:06:56 -0700 (PDT)
Message-ID: <1339002414.7078.38.camel@cumari.coelho.fi> (sfid-20120606_190702_595270_6A3F1E48)
Subject: Re: [PATCH] wlcore: add role_id to all the sched_scan commands
From: Luciano Coelho <coelho@ti.com>
To: Yoni Divinsky <yoni.divinsky@ti.com>
Cc: linux-wireless@vger.kernel.org, arik@wizery.com
Date: Wed, 06 Jun 2012 20:06:54 +0300
In-Reply-To: <1337157258-15163-1-git-send-email-yoni.divinsky@ti.com>
References: <1337157258-15163-1-git-send-email-yoni.divinsky@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-16 at 11:34 +0300, Yoni Divinsky wrote:
> Due to a need by the firmware when working in multirole
> the role id needs to be added to the structs of the
> following commands:
> CMD_CONNECTION_SCAN_CFG, CMD_CONNECTION_SCAN_SSID_CFG,
> CMD_START_PERIODIC_SCAN, CMD_STOP_PERIODIC_SCAN
> 
> Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
> Signed-off-by: Igal Chernobelsky <igalc@ti.com>
> ---

Applied and pushed!

--
Luca.

