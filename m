Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:54192 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab3FRSY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 14:24:29 -0400
Received: by mail-lb0-f171.google.com with SMTP id 13so3928549lba.16
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jun 2013 11:24:27 -0700 (PDT)
Message-ID: <51C0A5DB.1040509@cogentembedded.com> (sfid-20130618_202448_666587_DAAA3AF0)
Date: Tue, 18 Jun 2013 22:24:27 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, stable <stable@kernel.org>
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Fix duplicate if test
References: <1371579497-5575-1-git-send-email-Larry.Finger@lwfinger.net>
In-Reply-To: <1371579497-5575-1-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 06/18/2013 10:18 PM, Larry Finger wrote:

> A typo causes routine rtl92cu_phy_rf6052_set_cck_txpower() to test the
> same condition twice. The problem was found using cppcheck-1.49, and the
> proper fix was verified against the pre-mac80211 version of the code.

> This patch was originally included as commit 1288aa4, but was accidentally

    You probably forgot to specify the summary line of that commit.

> reverted in a later patch.

> Reported-by: David Binderman <dcb314@hotmail.com> [original report]
> Reported-by: Andrea Morello <andrea.merello@gmail.com> [report of accidental reversion]
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: stable <stable@kernel.org>  [back to 2.6.39]

WBR, Sergei

