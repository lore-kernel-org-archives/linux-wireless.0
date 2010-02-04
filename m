Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:47147 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498Ab0BDXzB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 18:55:01 -0500
Received: by pxi12 with SMTP id 12so3486424pxi.33
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2010 15:55:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1265319286-21861-1-git-send-email-benoit.papillault@free.fr>
References: <1265319286-21861-1-git-send-email-benoit.papillault@free.fr>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 4 Feb 2010 15:54:40 -0800
Message-ID: <43e72e891002041554r3fea0025kf2c2062b7fd55f0c@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Fix probe request filtering in IBSS mode
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 4, 2010 at 1:34 PM, Benoit Papillault
<benoit.papillault@free.fr> wrote:
> We only reply to probe request if either the requested SSID is the
> broadcast SSID or if the requested SSID matches our own SSID. This
> latter case was not properly handled since we were replying to different
> SSID with the same length as our own SSID.
>
> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>

Cc: stable@kernel.org it seems?

 Luis
