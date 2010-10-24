Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49987 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933103Ab0JXWYF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Oct 2010 18:24:05 -0400
Message-ID: <4CC4B210.2010608@lwfinger.net>
Date: Sun, 24 Oct 2010 17:24:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Nicolas Kaiser <nikai@nikai.net>
CC: Luciano Coelho <luciano.coelho@nokia.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless/wl1271: remove redundant if-statement
References: <20101025000744.17f7086e@absol.kitzblitz>
In-Reply-To: <20101025000744.17f7086e@absol.kitzblitz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/24/2010 05:07 PM, Nicolas Kaiser wrote:
> Apparently the return value of wl1271_ps_elp_sleep never gets
> checked anyway.

The patch is fine, but this comment is a little misleading as
wl1271_ps_elp_sleep() is void and cannot return a value.

Larry
