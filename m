Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f180.google.com ([209.85.161.180]:38307 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933461Ab0LUDsf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 22:48:35 -0500
Received: by gxk19 with SMTP id 19so2013172gxk.11
        for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 19:48:34 -0800 (PST)
Message-ID: <4D102390.7040300@lwfinger.net>
Date: Mon, 20 Dec 2010 21:48:32 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 7/7] rtlwifi: Use pci_pcie_cap()
References: <1292893316-26694-1-git-send-email-hauke@hauke-m.de> <1292893316-26694-8-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1292893316-26694-8-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/20/2010 07:01 PM, Hauke Mehrtens wrote:
> Use function pci_pcie_cap() instead of accessing struct member directly.
> 
> CC: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---

Is this change really necessary? The inline routine expands exactly to the code
that you replaced. The change just adds one extra layer of obscurity.

If this really is a desirable change, then add
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry
