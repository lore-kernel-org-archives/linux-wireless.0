Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44154 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab0LQDpG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 22:45:06 -0500
Received: by qyk12 with SMTP id 12so310239qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 19:45:05 -0800 (PST)
Message-ID: <4D0ADCBC.1000300@lwfinger.net>
Date: Thu, 16 Dec 2010 21:45:00 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [RFT] rtlwifi: use alloc_workqueue
References: <1292529589-5904-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1292529589-5904-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/16/2010 01:59 PM, John W. Linville wrote:
> create_workqueue is deprecated.  The workqueue usage does not seem to
> demand any special treatment, so do not set any flags either.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> I don't have the hardware to test...

Hold off on this one. It seems to break the driver, but I do not know why just yet.

Larry

