Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63274 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2AWRX4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jan 2012 12:23:56 -0500
Received: by ggnb1 with SMTP id b1so1448597ggn.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jan 2012 09:23:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1327338154-3806-1-git-send-email-eliad@wizery.com>
References: <1327338154-3806-1-git-send-email-eliad@wizery.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 23 Jan 2012 09:23:35 -0800
Message-ID: <CAB=NE6V26e6caZwCyO2chiZ_7iGVkoD_jtKsxfCLSHumrOp=Wg@mail.gmail.com> (sfid-20120123_182400_034546_A810F133)
Subject: Re: [PATCH] compat-wireless: fix wl12xx driver-select
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 23, 2012 at 9:02 AM, Eliad Peller <eliad@wizery.com> wrote:
> wl12xx is a possible choice for both group drivers and
> singular modules (making it impossible to build only
> the wl12xx module). change the group name to "ti" instead.
>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Is this a stable fix for linux-3.3.y branch of compat-wireless or only
for the master branch ?

  Luis
