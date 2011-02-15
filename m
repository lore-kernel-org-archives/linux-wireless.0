Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37801 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab1BOM6r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 07:58:47 -0500
Received: by eye27 with SMTP id 27so43467eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 04:58:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimTecR-W7iGzRWB_DxNVJoovK5SCuWfCmt8SUJo@mail.gmail.com>
References: <AANLkTi=-KJ+OSvDGuxYvDYQZ2ZdS8G8obbvodOXd9zQD@mail.gmail.com> <AANLkTimTecR-W7iGzRWB_DxNVJoovK5SCuWfCmt8SUJo@mail.gmail.com>
From: Ben Ruijl <benruyl@gmail.com>
Date: Tue, 15 Feb 2011 13:58:26 +0100
Message-ID: <AANLkTimx7=kYdWfe8FKL6oMyErE=3=GpXa-YrxkVVBG3@mail.gmail.com>
Subject: Re: r8712u: packet loss
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am experiencing packet loss of about 12 percent with the r8712u
staging driver with my WL-352v2 device. I'm not the only one with this
problem (https://bbs.archlinux.org/viewtopic.php?id=112120). I haven't
done a git bisect yet, but I know the problem is in both the 2.6.37
version and the latest version.

Regards,

Ben
