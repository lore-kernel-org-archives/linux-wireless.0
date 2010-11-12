Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59698 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab0KLTtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 14:49:13 -0500
Received: by iwn10 with SMTP id 10so3839957iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 11:49:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1289589685-16372-2-git-send-email-hauke@hauke-m.de>
References: <1289589685-16372-1-git-send-email-hauke@hauke-m.de> <1289589685-16372-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 12 Nov 2010 11:48:52 -0800
Message-ID: <AANLkTimhMFtyYkf=sn0sfdQ7G0N3xa0BTNeWS6OC7Z1e@mail.gmail.com>
Subject: Re: [PATCH 2/2] compat-wireless: fix compile error with iwl
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 12, 2010 at 11:21 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> The header file declares the const.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied and pushed, thanks!

 Luis
