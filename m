Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63063 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2GSJt0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 05:49:26 -0400
Received: by obbuo13 with SMTP id uo13so3474279obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jul 2012 02:49:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1375660.IC4Ixsn6lK@ivanich>
References: <1375660.IC4Ixsn6lK@ivanich>
Date: Thu, 19 Jul 2012 15:19:25 +0530
Message-ID: <CAD2nsn2fMJogNmfzee0NyrvBxnfi=5KhUny+8ayu-XM5ZGPYog@mail.gmail.com> (sfid-20120719_114931_269230_DCD0083C)
Subject: Re: hostapd locks during restart
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ivanich <ivanich@ivanich.org.ua>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 19, 2012 at 2:24 PM, Ivanich <ivanich@ivanich.org.ua> wrote:
> In the latest wireless-testing.git hostapd deadlock during restart, using
> rtl8192ce in AP mode.

please check if this is related to
http://comments.gmane.org/gmane.linux.kernel.wireless.general/95061

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
