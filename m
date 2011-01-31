Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44266 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab1AaSnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:43:24 -0500
Received: by qyj19 with SMTP id 19so3741780qyj.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 10:43:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1296460529-13669-1-git-send-email-mshajakhan@atheros.com>
References: <1296460529-13669-1-git-send-email-mshajakhan@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 31 Jan 2011 10:43:02 -0800
Message-ID: <AANLkTimbtr8zKf6Nj0GmTccKU2u2ubTkL3a5BVSGfUK0@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Fix memory leak due to failed PAPRD frames
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 30, 2011 at 11:55 PM, Mohammed Shafi Shajakhan
<mshajakhan@atheros.com> wrote:
> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
>
> free the skb's when the Tx of PAPRD frames fails and also add a debug
> message indicating that.
>
> Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

Is this a stable fix?

 Luis
