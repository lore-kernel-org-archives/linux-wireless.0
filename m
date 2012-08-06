Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43604 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675Ab2HFTYO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 15:24:14 -0400
Received: by obbuo13 with SMTP id uo13so6303319obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 12:24:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344275446-22668-1-git-send-email-ozancag@gmail.com>
References: <1344275446-22668-1-git-send-email-ozancag@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 6 Aug 2012 12:23:53 -0700
Message-ID: <CAB=NE6V1-Nw7+Zvw65=rYMbVR2CqgcR7d1cpqE8QfBno8=cthg@mail.gmail.com> (sfid-20120806_212417_798842_B256F345)
Subject: Re: [PATCH] compat-wireless: Nuke defconfigs
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: mcgrof@kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 6, 2012 at 10:50 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> Drop defconfigs that were destined to enable specific builds, but
> they are not used at all. Let's clean them.
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>

Applied and pushed, thanks!

  Luis
