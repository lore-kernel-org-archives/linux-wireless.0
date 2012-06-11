Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57674 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab2FKXQi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 19:16:38 -0400
Received: by obbtb18 with SMTP id tb18so7395665obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2012 16:16:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339451179-21171-1-git-send-email-ozancag@gmail.com>
References: <1339451179-21171-1-git-send-email-ozancag@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 11 Jun 2012 16:16:17 -0700
Message-ID: <CAB=NE6WZFNZeZgW4qu0Z7NCQcHRXjOwZ1f9fNez=yGygGwOQjw@mail.gmail.com> (sfid-20120612_011713_715528_B7063A51)
Subject: Re: [PATCH] bin/ckmake: Drop Ubuntu check
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: mcgrof@kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 11, 2012 at 2:46 PM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> Don't check for distribution as it is now possible to use ckmake
> on every distribution.
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>

Thanks, applied and pushed all! Just next time please add a prefix to
the subject so others know what this patch is for, a "[PATCH] compat:
foo" for example works.

  Luis
