Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36559 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756340Ab2DYSS1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 14:18:27 -0400
Message-ID: <4F983FE9.3040005@hauke-m.de> (sfid-20120425_201829_653046_6D52B66B)
Date: Wed, 25 Apr 2012 20:18:17 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Nathan Hintz <nlhintz@hotmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/6] bcma: Find names of non BCM cores
References: <1335334519-18820-1-git-send-email-nlhintz@hotmail.com> <BLU0-SMTP82C0BC8A30291EC08FBF14AC270@phx.gbl>
In-Reply-To: <BLU0-SMTP82C0BC8A30291EC08FBF14AC270@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nathan,

On 04/25/2012 08:15 AM, Nathan Hintz wrote:
> ---
>  drivers/bcma/scan.c |   54 +++++++++++++++++++++++++++++++++++++-------------
>  1 files changed, 40 insertions(+), 14 deletions(-)
> 
I reviewed all patches 6 patches and they are looking good to me, just
fix the thing Florian mentioned and add a Signed-off-by line.

Hauke
