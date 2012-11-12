Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:44640 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab2KLXbN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 18:31:13 -0500
Received: by mail-ia0-f174.google.com with SMTP id y25so240464iay.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 15:31:13 -0800 (PST)
Message-ID: <50A186BD.6060908@lwfinger.net> (sfid-20121113_003116_708954_0AF76B57)
Date: Mon, 12 Nov 2012 17:31:09 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Maxim Mikityanskiy <maxtram95@gmail.com>
CC: greg@kroah.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 15/17] Removed unused fields in r8180_priv
References: <1352757511-26957-1-git-send-email-maxtram95@gmail.com> <1352757511-26957-16-git-send-email-maxtram95@gmail.com>
In-Reply-To: <1352757511-26957-16-git-send-email-maxtram95@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/2012 03:58 PM, Maxim Mikityanskiy wrote:
> Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
> ---
>   r8180.h       |   10 ----------
>   r8180_core.c  |   49 +++----------------------------------------------
>   r8185b_init.c |    6 ++----
>   3 files changed, 5 insertions(+), 60 deletions(-)

This patch failed to apply, even after the directory level was fixed. A wiggle 
run fixed it with no manual intervention, but there is some kind of problem. My 
base system is the staging tree, with a pull today.

Larry

