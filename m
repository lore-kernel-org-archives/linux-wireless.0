Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:44704 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab0LRHNI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 02:13:08 -0500
Received: by bwz16 with SMTP id 16so1752589bwz.4
        for <linux-wireless@vger.kernel.org>; Fri, 17 Dec 2010 23:13:07 -0800 (PST)
Message-ID: <4D0C5F00.3040002@kernel.org>
Date: Sat, 18 Dec 2010 08:13:04 +0100
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFT] rtlwifi: use alloc_workqueue
References: <1292529589-5904-1-git-send-email-linville@tuxdriver.com> <4D0C0E5F.4030605@lwfinger.net>
In-Reply-To: <4D0C0E5F.4030605@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On 12/18/2010 02:29 AM, Larry Finger wrote:
> After further testing, this patch is OK. The problem I saw had another source.
> 
> Add Tested-by: Larry Finger

Thanks for verifying.

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
